const configuredApiUrl = import.meta.env.VITE_API_URL;
const browserHost = typeof window !== "undefined" ? window.location.hostname : "127.0.0.1";
const defaultApiUrl = import.meta.env.PROD ? "" : `http://${browserHost}:8000`;

export const API_URL = (configuredApiUrl ?? defaultApiUrl).replace(/\/$/, "");
