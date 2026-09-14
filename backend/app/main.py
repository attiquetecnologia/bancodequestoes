from typing import Annotated

from fastapi import Depends, FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware

from .config import cors_origins
from .db import database_connection


app = FastAPI(
    title="Banco de Questões API",
    version="0.1.0",
    description="API para catalogação, consulta e aplicação de questões.",
)
app.add_middleware(
    CORSMiddleware,
    allow_origins=cors_origins(),
    allow_credentials=True,
    allow_methods=["GET", "POST", "PATCH", "DELETE", "OPTIONS"],
    allow_headers=["Authorization", "Content-Type"],
)

Connection = Annotated[object, Depends(database_connection)]


def option_payload(option: object, include_answer: bool = False) -> dict:
    payload = {
        "id": option["id"],
        "position": option["position"],
        "content": option["content"],
    }
    if include_answer:
        payload["is_correct"] = bool(option["is_correct"])
    return payload


def question_payload(connection: object, question: object, include_answer: bool = False) -> dict:
    options = connection.execute(
        """
        SELECT id, position, content, is_correct
        FROM option_item
        WHERE question_id = ?
        ORDER BY position
        """,
        (question["id"],),
    ).fetchall()
    subjects = connection.execute(
        """
        SELECT s.id, s.name, s.slug
        FROM subject s
        JOIN question_subject qs ON qs.subject_id = s.id
        WHERE qs.question_id = ?
        ORDER BY s.name
        """,
        (question["id"],),
    ).fetchall()
    return {
        "id": question["id"],
        "statement": question["statement"],
        "explanation": question["explanation"],
        "hint": question["hint"],
        "question_type": question["question_type"],
        "difficulty": question["difficulty"],
        "status": question["status"],
        "source": {
            "id": question["source_id"],
            "name": question["source_name"],
            "institution": question["institution"],
            "year": question["source_year"],
        },
        "subjects": [dict(subject) for subject in subjects],
        "options": [option_payload(option, include_answer) for option in options],
    }


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/api/v1/subjects")
def list_subjects(connection: Connection) -> list[dict]:
    rows = connection.execute(
        "SELECT id, parent_id, name, slug FROM subject ORDER BY name"
    ).fetchall()
    return [dict(row) for row in rows]


@app.get("/api/v1/sources")
def list_sources(connection: Connection) -> list[dict]:
    rows = connection.execute(
        """
        SELECT id, name, institution, year, reference_url, usage_status
        FROM source
        ORDER BY year DESC, name
        """
    ).fetchall()
    return [dict(row) for row in rows]


@app.get("/api/v1/questions")
def list_questions(
    connection: Connection,
    search: str | None = Query(default=None, alias="q"),
    subject_id: int | None = None,
    source_id: int | None = None,
    difficulty: str | None = None,
    status: str = "published",
    page: int = Query(default=1, ge=1),
    page_size: int = Query(default=20, ge=1, le=100),
) -> dict:
    filters = ["q.status = ?"]
    parameters: list[object] = [status]
    if search:
        filters.append("q.statement LIKE ?")
        parameters.append(f"%{search}%")
    if subject_id is not None:
        filters.append(
            "EXISTS (SELECT 1 FROM question_subject qsf WHERE qsf.question_id = q.id AND qsf.subject_id = ?)"
        )
        parameters.append(subject_id)
    if source_id is not None:
        filters.append("q.source_id = ?")
        parameters.append(source_id)
    if difficulty:
        filters.append("q.difficulty = ?")
        parameters.append(difficulty)

    where_clause = " AND ".join(filters)
    total = connection.execute(
        f"SELECT COUNT(*) FROM question q WHERE {where_clause}", parameters
    ).fetchone()[0]
    offset = (page - 1) * page_size
    rows = connection.execute(
        f"""
        SELECT q.*, s.name AS source_name, s.institution, s.year AS source_year
        FROM question q
        JOIN source s ON s.id = q.source_id
        WHERE {where_clause}
        ORDER BY q.id
        LIMIT ? OFFSET ?
        """,
        [*parameters, page_size, offset],
    ).fetchall()
    return {
        "items": [question_payload(connection, row) for row in rows],
        "page": page,
        "page_size": page_size,
        "total": total,
        "pages": (total + page_size - 1) // page_size,
    }


@app.get("/api/v1/questions/{question_id}")
def get_question(
    question_id: int,
    connection: Connection,
    include_answer: bool = False,
) -> dict:
    row = connection.execute(
        """
        SELECT q.*, s.name AS source_name, s.institution, s.year AS source_year
        FROM question q
        JOIN source s ON s.id = q.source_id
        WHERE q.id = ?
        """,
        (question_id,),
    ).fetchone()
    if row is None:
        raise HTTPException(status_code=404, detail="Questão não encontrada")
    return question_payload(connection, row, include_answer)


@app.get("/api/v1/simulations")
def list_simulations(connection: Connection) -> list[dict]:
    rows = connection.execute(
        """
        SELECT id, title, duration_minutes, question_count, status, created_at
        FROM simulation
        WHERE status = 'published'
        ORDER BY created_at DESC, id DESC
        """
    ).fetchall()
    return [dict(row) for row in rows]