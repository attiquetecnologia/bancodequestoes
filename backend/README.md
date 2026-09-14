# API FastAPI

## Executar localmente

```bash
uv venv .venv
uv pip install --python .venv/bin/python -e '.[dev]'
source .venv/bin/activate
uvicorn app.main:app --reload --app-dir backend
```

O arquivo `uv.lock` mantém as versões resolvidas para instalações reproduzíveis.

A API ficará disponível em `http://localhost:8000`, com documentação em `/docs`.

Variáveis opcionais:

```env
DATABASE_PATH=/caminho/para/database/bancoquestoes.db
CORS_ORIGINS=http://localhost:5173,http://127.0.0.1:5173,https://app.exemplo.com
```