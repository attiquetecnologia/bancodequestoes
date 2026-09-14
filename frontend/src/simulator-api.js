const API_URL = import.meta.env.VITE_API_URL || "http://localhost:8000";

export async function getSimulation(simulationId = 1) {
  const response = await fetch(`${API_URL}/api/v1/simulations/${simulationId}`);
  if (!response.ok) throw new Error(`Não foi possível carregar o simulado (${response.status})`);
  return response.json();
}

export async function gradeSimulation(simulationId, answers) {
  const response = await fetch(`${API_URL}/api/v1/simulations/${simulationId}/grade`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ answers }),
  });
  if (!response.ok) throw new Error(`Não foi possível corrigir o simulado (${response.status})`);
  return response.json();
}
