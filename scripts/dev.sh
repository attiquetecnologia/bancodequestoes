#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKEND_DIR="$ROOT_DIR/backend"
FRONTEND_DIR="$ROOT_DIR/frontend"

if ! command -v uv >/dev/null 2>&1; then
  echo "Erro: uv não encontrado. Instale o uv antes de executar este script." >&2
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "Erro: npm não encontrado. Instale Node.js/npm antes de executar este script." >&2
  exit 1
fi

if [[ ! -x "$BACKEND_DIR/.venv/bin/uvicorn" ]]; then
  echo "Ambiente Python não encontrado. Criando com uv..."
  uv venv "$BACKEND_DIR/.venv"
  uv pip install --python "$BACKEND_DIR/.venv/bin/python" -e "$BACKEND_DIR"
fi

if [[ ! -d "$FRONTEND_DIR/node_modules" ]]; then
  echo "Dependências do frontend não encontradas. Instalando com npm..."
  npm install --prefix "$FRONTEND_DIR"
fi

cleanup() {
  trap - INT TERM EXIT
  [[ -n "${BACKEND_PID:-}" ]] && kill "$BACKEND_PID" 2>/dev/null || true
  [[ -n "${FRONTEND_PID:-}" ]] && kill "$FRONTEND_PID" 2>/dev/null || true
}

trap cleanup INT TERM EXIT

echo "API:      http://localhost:8000/docs"
echo "Frontend: http://localhost:5173/"
echo "Pressione Ctrl+C para encerrar os dois serviços."

(cd "$ROOT_DIR" && "$BACKEND_DIR/.venv/bin/uvicorn" app.main:app --app-dir "$BACKEND_DIR" --host 127.0.0.1 --port 8000 --reload) &
BACKEND_PID=$!

(cd "$ROOT_DIR" && npm run dev --prefix "$FRONTEND_DIR" -- --host 127.0.0.1 --strictPort) &
FRONTEND_PID=$!

wait -n "$BACKEND_PID" "$FRONTEND_PID"