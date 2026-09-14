PRAGMA foreign_keys = ON;

BEGIN;

CREATE TABLE IF NOT EXISTS app_user (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE COLLATE NOCASE,
    role TEXT NOT NULL CHECK (role IN ('admin', 'editor', 'student')),
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS source (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    institution TEXT,
    year INTEGER CHECK (year IS NULL OR year BETWEEN 1900 AND 2100),
    reference_url TEXT,
    usage_status TEXT NOT NULL DEFAULT 'own'
        CHECK (usage_status IN ('own', 'licensed', 'reference_only')),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS subject (
    id INTEGER PRIMARY KEY,
    parent_id INTEGER REFERENCES subject(id) ON DELETE RESTRICT,
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (parent_id, name)
);

CREATE TABLE IF NOT EXISTS question (
    id INTEGER PRIMARY KEY,
    source_id INTEGER NOT NULL REFERENCES source(id) ON DELETE RESTRICT,
    author_id INTEGER NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
    statement TEXT NOT NULL CHECK (length(trim(statement)) >= 10),
    explanation TEXT,
    hint TEXT,
    question_type TEXT NOT NULL DEFAULT 'single_choice'
        CHECK (question_type = 'single_choice'),
    difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard')),
    status TEXT NOT NULL DEFAULT 'draft'
        CHECK (status IN ('draft', 'published', 'archived')),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS option_item (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL REFERENCES question(id) ON DELETE CASCADE,
    position INTEGER NOT NULL CHECK (position BETWEEN 1 AND 5),
    content TEXT NOT NULL CHECK (length(trim(content)) >= 1),
    is_correct INTEGER NOT NULL DEFAULT 0 CHECK (is_correct IN (0, 1)),
    UNIQUE (question_id, position)
);

CREATE TABLE IF NOT EXISTS question_subject (
    question_id INTEGER NOT NULL REFERENCES question(id) ON DELETE CASCADE,
    subject_id INTEGER NOT NULL REFERENCES subject(id) ON DELETE RESTRICT,
    PRIMARY KEY (question_id, subject_id)
);

CREATE TABLE IF NOT EXISTS simulation (
    id INTEGER PRIMARY KEY,
    author_id INTEGER NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
    title TEXT NOT NULL,
    duration_minutes INTEGER CHECK (duration_minutes IS NULL OR duration_minutes > 0),
    question_count INTEGER NOT NULL CHECK (question_count > 0),
    status TEXT NOT NULL DEFAULT 'draft'
        CHECK (status IN ('draft', 'published', 'archived')),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS simulation_question (
    simulation_id INTEGER NOT NULL REFERENCES simulation(id) ON DELETE CASCADE,
    question_id INTEGER NOT NULL REFERENCES question(id) ON DELETE RESTRICT,
    position INTEGER NOT NULL CHECK (position > 0),
    points REAL NOT NULL DEFAULT 1 CHECK (points > 0),
    statement_snapshot TEXT NOT NULL,
    options_snapshot TEXT NOT NULL CHECK (json_valid(options_snapshot)),
    PRIMARY KEY (simulation_id, question_id),
    UNIQUE (simulation_id, position)
);

CREATE TABLE IF NOT EXISTS attempt (
    id INTEGER PRIMARY KEY,
    simulation_id INTEGER NOT NULL REFERENCES simulation(id) ON DELETE RESTRICT,
    user_id INTEGER NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
    started_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    finished_at TEXT,
    score REAL CHECK (score IS NULL OR score >= 0),
    status TEXT NOT NULL DEFAULT 'in_progress'
        CHECK (status IN ('in_progress', 'finished', 'cancelled')),
    CHECK (finished_at IS NULL OR status <> 'in_progress')
);

CREATE TABLE IF NOT EXISTS attempt_answer (
    id INTEGER PRIMARY KEY,
    attempt_id INTEGER NOT NULL REFERENCES attempt(id) ON DELETE CASCADE,
    question_id INTEGER NOT NULL REFERENCES question(id) ON DELETE RESTRICT,
    selected_option_id INTEGER REFERENCES option_item(id) ON DELETE RESTRICT,
    option_order TEXT NOT NULL CHECK (json_valid(option_order)),
    is_correct INTEGER CHECK (is_correct IS NULL OR is_correct IN (0, 1)),
    elapsed_seconds INTEGER CHECK (elapsed_seconds IS NULL OR elapsed_seconds >= 0),
    UNIQUE (attempt_id, question_id)
);

CREATE INDEX IF NOT EXISTS idx_question_filter
    ON question(status, difficulty, source_id);
CREATE INDEX IF NOT EXISTS idx_question_subject_subject
    ON question_subject(subject_id, question_id);
CREATE INDEX IF NOT EXISTS idx_option_question
    ON option_item(question_id, position);
CREATE INDEX IF NOT EXISTS idx_simulation_status
    ON simulation(status, created_at);
CREATE INDEX IF NOT EXISTS idx_attempt_user
    ON attempt(user_id, started_at);

CREATE TRIGGER IF NOT EXISTS question_updated_at
AFTER UPDATE OF statement, explanation, hint, difficulty, status ON question
FOR EACH ROW
BEGIN
    UPDATE question SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS question_publish_validation
BEFORE UPDATE OF status ON question
FOR EACH ROW
WHEN NEW.status = 'published'
BEGIN
    SELECT CASE
        WHEN (SELECT COUNT(*) FROM option_item WHERE question_id = NEW.id) NOT IN (4, 5)
        THEN RAISE(ABORT, 'published question must have 4 or 5 options')
    END;
    SELECT CASE
        WHEN (SELECT COUNT(*) FROM option_item WHERE question_id = NEW.id AND is_correct = 1) <> 1
        THEN RAISE(ABORT, 'published question must have exactly one correct option')
    END;
    SELECT CASE
        WHEN (SELECT COUNT(*) FROM question_subject WHERE question_id = NEW.id) = 0
        THEN RAISE(ABORT, 'published question must have at least one subject')
    END;
END;

CREATE TRIGGER IF NOT EXISTS simulation_question_published_only
BEFORE INSERT ON simulation_question
FOR EACH ROW
WHEN (SELECT status FROM question WHERE id = NEW.question_id) <> 'published'
BEGIN
    SELECT RAISE(ABORT, 'only published questions can enter a simulation');
END;

COMMIT;