import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import Simulator from "./Simulator.jsx";
import "./simulator.css";

createRoot(document.getElementById("simulator-root")).render(
  <StrictMode><Simulator /></StrictMode>,
);
