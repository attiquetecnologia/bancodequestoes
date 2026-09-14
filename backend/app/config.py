import os
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_DATABASE_URL = PROJECT_ROOT / "database" / "bancoquestoes.db"


def database_path() -> Path:
    configured_path = os.getenv("DATABASE_PATH")
    return Path(configured_path) if configured_path else DEFAULT_DATABASE_URL


def cors_origins() -> list[str]:
    configured_origins = os.getenv("CORS_ORIGINS", "http://localhost:5173,http://localhost:5500")
    return [origin.strip() for origin in configured_origins.split(",") if origin.strip()]