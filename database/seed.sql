PRAGMA foreign_keys = ON;

BEGIN;

INSERT INTO app_user (id, name, email, role) VALUES
    (1, 'Administrador do Banco', 'admin@bancoquestoes.local', 'admin'),
    (2, 'Ana Editora', 'ana.editor@bancoquestoes.local', 'editor'),
    (3, 'Carlos Estudante', 'carlos.aluno@bancoquestoes.local', 'student');

INSERT INTO source (id, name, institution, year, usage_status) VALUES
    (1, 'Autoria própria', 'Banco de Questões', 2026, 'own'),
    (2, 'Prova de Tecnologia da Informação', 'Exemplo Educacional', 2025, 'reference_only');

INSERT INTO subject (id, parent_id, name, slug) VALUES
    (1, NULL, 'Tecnologia', 'tecnologia'),
    (2, 1, 'Banco de Dados', 'tecnologia-banco-de-dados'),
    (3, 2, 'SQL', 'tecnologia-banco-de-dados-sql'),
    (4, 2, 'Modelagem Relacional', 'tecnologia-banco-de-dados-modelagem'),
    (5, 1, 'Lógica de Programação', 'tecnologia-logica-de-programacao');

INSERT INTO question
    (id, source_id, author_id, statement, explanation, hint, difficulty, status)
VALUES
    (1, 1, 2,
     'Qual comando SQL é utilizado para combinar linhas de duas ou mais tabelas com base em uma coluna relacionada?',
     'A cláusula JOIN combina registros relacionados e permite consultar dados distribuídos entre tabelas.',
     'Pense na operação que conecta tabelas por uma chave relacionada.',
     'easy', 'draft'),
    (2, 2, 2,
     'Em um banco de dados relacional, qual é a finalidade principal de uma chave primária?',
     'A chave primária identifica cada registro de forma única e não deve aceitar valores nulos.',
     'Ela identifica unicamente uma linha da tabela.',
     'medium', 'draft'),
    (3, 1, 2,
     'Qual estrutura de repetição é mais adequada quando a quantidade de iterações é conhecida previamente?',
     'O laço for reúne inicialização, condição e incremento, sendo adequado para contagens conhecidas.',
     'Procure a estrutura que normalmente possui contador explícito.',
     'easy', 'draft');

INSERT INTO option_item (question_id, position, content, is_correct) VALUES
    (1, 1, 'JOIN', 1),
    (1, 2, 'GROUP BY', 0),
    (1, 3, 'ORDER BY', 0),
    (1, 4, 'CHECK', 0),
    (2, 1, 'Armazenar várias tabelas dentro de uma única coluna', 0),
    (2, 2, 'Identificar unicamente cada registro da tabela', 1),
    (2, 3, 'Substituir todos os índices do banco', 0),
    (2, 4, 'Permitir valores duplicados na identificação', 0),
    (2, 5, 'Excluir automaticamente registros antigos', 0),
    (3, 1, 'if', 0),
    (3, 2, 'for', 1),
    (3, 3, 'switch', 0),
    (3, 4, 'try/catch', 0);

INSERT INTO question_subject (question_id, subject_id) VALUES
    (1, 3),
    (2, 4),
    (3, 5);

UPDATE question SET status = 'published' WHERE id IN (1, 2, 3);

INSERT INTO simulation
    (id, author_id, title, duration_minutes, question_count, status)
VALUES
    (1, 2, 'Diagnóstico de Banco de Dados e Lógica', 30, 3, 'published');

INSERT INTO simulation_question
    (simulation_id, question_id, position, points, statement_snapshot, options_snapshot)
SELECT 1, q.id, q.id, 1, q.statement,
       json_group_array(json_object(
           'position', o.position,
           'content', o.content,
           'is_correct', o.is_correct
       ))
FROM question q
JOIN option_item o ON o.question_id = q.id
WHERE q.id IN (1, 2, 3)
GROUP BY q.id, q.statement;

INSERT INTO attempt
    (id, simulation_id, user_id, started_at, finished_at, score, status)
VALUES
    (1, 1, 3, '2026-09-14 09:00:00', '2026-09-14 09:12:10', 2, 'finished');

INSERT INTO attempt_answer
    (attempt_id, question_id, selected_option_id, option_order, is_correct, elapsed_seconds)
VALUES
    (1, 1, 1, '[1,2,3,4]', 1, 95),
    (1, 2, 6, '[5,6,7,8,9]', 1, 110),
    (1, 3, 9, '[9,10,11,12]', 0, 80);

COMMIT;