import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  appType: "spa",
  build: {
    rollupOptions: {
      input: {
        main: "index.html",
        simulator: "simulador.html",
      },
    },
  },
  server: {
    port: 5173,
    open: "/index.html",
  },
});
