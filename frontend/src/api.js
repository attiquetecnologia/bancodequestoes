import { API_URL } from "./config";

async function request(path) {
  const response = await fetch(`${API_URL}${path}`);
  if (!response.ok) throw new Error(`API respondeu com status ${response.status}`);
  return response.json();
}

export function getSubjects() { return request("/api/v1/subjects"); }
export function getSimulations() { return request("/api/v1/simulations"); }
export function getQuestions({ search, subjectId, difficulty, page = 1 }) {
  const params = new URLSearchParams({ page, page_size: 8 });
  if (search) params.set("q", search);
  if (subjectId) params.set("subject_id", subjectId);
  if (difficulty) params.set("difficulty", difficulty);
  return request(`/api/v1/questions?${params}`);
}
