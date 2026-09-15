#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKEND_DIR="$ROOT_DIR/backend"
FRONTEND_DIR="$ROOT_DIR/frontend"
LAN_IP="${LAN_IP:-$(hostname -I 2>/dev/null | awk '{print $1}')}"

if [[ -z "${LAN_IP// }" ]]; then
  echo "Erro: não foi possível descobrir o IP da rede local. Use LAN_IP=seu.ip.local ./scripts/dev.sh" >&2
  exit 1
fi

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

export CORS_ORIGINS="${CORS_ORIGINS:-http://localhost:5173,http://127.0.0.1:5173,http://${LAN_IP}:5173}"
export VITE_API_URL="${VITE_API_URL:-http://${LAN_IP}:8000}"

echo "API local:      http://${LAN_IP}:8000/docs"
echo "Frontend local: http://${LAN_IP}:5173/"
echo "Simulador:      http://${LAN_IP}:5173/simulador.html"
echo "API configurada no frontend: ${VITE_API_URL}"
echo "Pressione Ctrl+C para encerrar os dois serviços."

(cd "$ROOT_DIR" && "$BACKEND_DIR/.venv/bin/uvicorn" app.main:app --app-dir "$BACKEND_DIR" --host 0.0.0.0 --port 8000 --reload) &
BACKEND_PID=$!

(cd "$ROOT_DIR" && npm run dev --prefix "$FRONTEND_DIR" -- --host 0.0.0.0 --strictPort) &
FRONTEND_PID=$!

wait -n "$BACKEND_PID" "$FRONTEND_PID"