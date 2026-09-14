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

## Deploy no Render

Use a configuração declarativa em `../render.yaml` ou configure manualmente:

```text
Root Directory: backend
Build Command: pip install -r requirements.txt
Start Command: uvicorn app.main:app --host 0.0.0.0 --port $PORT
Health Check Path: /health
```

Não use `gunicorn your_application.wsgi`: esse comando é um placeholder para aplicações WSGI e não existe neste backend FastAPI. O `requirements.txt` instala `uvicorn[standard]`, que é o servidor ASGI adequado.

Se o SQLite for usado no Render, configure um disco persistente montado em `/var/data` e a variável `DATABASE_PATH=/var/data/bancoquestoes.db`. Sem disco persistente, o arquivo pode ser perdido em um novo deploy.

Variáveis opcionais:

```env
DATABASE_PATH=/caminho/para/database/bancoquestoes.db
CORS_ORIGINS=http://localhost:5173,http://127.0.0.1:5173,https://app.exemplo.com
```