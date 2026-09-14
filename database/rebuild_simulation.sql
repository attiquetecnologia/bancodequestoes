PRAGMA foreign_keys = ON;

BEGIN;

DELETE FROM attempt_answer;
DELETE FROM attempt;
DELETE FROM simulation_question;
DELETE FROM simulation;

INSERT INTO simulation
    (id, author_id, title, duration_minutes, question_count, status)
SELECT 1, 2, 'Simulado SAEP 2026 - Banco de Questões', 120, COUNT(*), 'published'
FROM question
WHERE status = 'published';

INSERT INTO simulation_question
    (simulation_id, question_id, position, points, statement_snapshot, options_snapshot)
SELECT 1,
       q.id,
       q.id,
       1,
       q.statement,
       json_group_array(json_object(
           'position', o.position,
           'content', o.content,
           'is_correct', o.is_correct
       ))
FROM question q
JOIN option_item o ON o.question_id = q.id
WHERE q.status = 'published'
GROUP BY q.id, q.statement;

COMMIT;
