import fs from "node:fs";

const htmlPath = new URL("../frontend/index.html", import.meta.url);
const html = fs.readFileSync(htmlPath, "utf8");
const marker = "const questionsData = ";
const start = html.indexOf(marker);
const end = html.indexOf("\n        ];", start);

if (start < 0 || end < 0) {
  throw new Error("questionsData não encontrado no frontend/index.html");
}

const arraySource = html.slice(start + marker.length, end + "\n        ]".length);
const questions = Function(`"use strict"; return (${arraySource});`)();

if (!Array.isArray(questions) || questions.length === 0) {
  throw new Error("questionsData está vazio ou inválido");
}

const sqlString = (value) => `'${String(value ?? "").replaceAll("'", "''")}'`;
const slugify = (value) => value
  .normalize("NFD")
  .replace(/[\u0300-\u036f]/g, "")
  .toLowerCase()
  .replace(/[^a-z0-9]+/g, "-")
  .replace(/^-|-$/g, "");

const tags = [...new Set(questions.map((question) => question.tag))];
const lines = [
  "PRAGMA foreign_keys = ON;",
  "BEGIN;",
  "DELETE FROM attempt_answer;",
  "DELETE FROM attempt;",
  "DELETE FROM simulation_question;",
  "DELETE FROM simulation;",
  "DELETE FROM question_subject;",
  "DELETE FROM option_item;",
  "DELETE FROM question;",
  "INSERT OR IGNORE INTO source (id, name, institution, year, usage_status) VALUES (3, 'Simulador SAEP 2026', 'SENAI-SP', 2026, 'reference_only');",
];

for (const tag of tags) {
  lines.push(
    `INSERT OR IGNORE INTO subject (parent_id, name, slug) VALUES (1, ${sqlString(tag)}, ${sqlString(`tecnologia-${slugify(tag)}`)});`,
  );
}

for (const question of questions) {
  const difficulty = question.id % 3 === 0 ? "hard" : question.id % 2 === 0 ? "medium" : "easy";
  lines.push(
    `INSERT INTO question (id, source_id, author_id, statement, explanation, hint, difficulty, status) VALUES (${question.id}, 3, 2, ${sqlString(question.question)}, ${sqlString(question.options.find((option) => option.isCorrect)?.rationale)}, ${sqlString(question.hint)}, ${sqlString(difficulty)}, 'draft');`,
  );
  question.options.forEach((option, index) => {
    lines.push(
      `INSERT INTO option_item (question_id, position, content, is_correct) VALUES (${question.id}, ${index + 1}, ${sqlString(option.text)}, ${option.isCorrect ? 1 : 0});`,
    );
  });
  lines.push(
    `INSERT INTO question_subject (question_id, subject_id) SELECT ${question.id}, id FROM subject WHERE slug = ${sqlString(`tecnologia-${slugify(question.tag)}`)};`,
    `UPDATE question SET status = 'published' WHERE id = ${question.id};`,
  );
}

lines.push(
  `INSERT INTO simulation (id, author_id, title, duration_minutes, question_count, status) VALUES (1, 2, 'Simulado SAEP 2026 - Banco de Questões', 120, ${questions.length}, 'published');`,
  "INSERT INTO simulation_question (simulation_id, question_id, position, points, statement_snapshot, options_snapshot) SELECT 1, q.id, q.id, 1, q.statement, json_group_array(json_object('position', o.position, 'content', o.content, 'is_correct', o.is_correct)) FROM question q JOIN option_item o ON o.question_id = q.id GROUP BY q.id, q.statement;",
);

lines.push("COMMIT;");
process.stdout.write(`${lines.join("\n")}\n`);