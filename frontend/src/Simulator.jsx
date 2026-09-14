import { useEffect, useState } from "react";
import { ArrowLeft, ArrowRight, Award, BookOpen, Check, ChevronLeft, ChevronRight, Clock3, Lightbulb, ListChecks, RotateCcw, X } from "lucide-react";
import { getSimulation, gradeSimulation } from "./simulator-api";

const LETTERS = ["A", "B", "C", "D", "E"];

export default function Simulator() {
  const [simulation, setSimulation] = useState(null);
  const [screen, setScreen] = useState("welcome");
  const [current, setCurrent] = useState(0);
  const [answers, setAnswers] = useState({});
  const [seconds, setSeconds] = useState(0);
  const [hintOpen, setHintOpen] = useState(false);
  const [error, setError] = useState("");
  const [result, setResult] = useState(null);

  useEffect(() => {
    const simulationId = new URLSearchParams(window.location.search).get("simulation_id") || 1;
    getSimulation(simulationId).then(setSimulation).catch((requestError) => setError(requestError.message));
  }, []);

  useEffect(() => {
    if (screen !== "exam" || !simulation) return undefined;
    const timer = setInterval(() => setSeconds((value) => value + 1), 1000);
    return () => clearInterval(timer);
  }, [screen, simulation]);

  const question = simulation?.questions[current];
  const answeredCount = Object.keys(answers).length;
  const score = result?.score ?? 0;

  const start = () => { setAnswers({}); setResult(null); setCurrent(0); setSeconds(0); setScreen("exam"); };
  const selectAnswer = (position) => setAnswers((value) => ({ ...value, [question.id]: position }));
  const finish = async () => {
    try {
      setResult(await gradeSimulation(simulation.id, answers));
      setScreen("results");
    } catch (requestError) {
      setError(requestError.message);
    }
  };
  const next = () => current < simulation.questions.length - 1 ? setCurrent((value) => value + 1) : finish();
  const previous = () => setCurrent((value) => Math.max(0, value - 1));
  const formatTime = (value) => `${String(Math.floor(value / 60)).padStart(2, "0")}:${String(value % 60).padStart(2, "0")}`;

  if (error) return <Shell><div className="sim-error"><X size={22} /><h2>Não foi possível abrir o simulado</h2><p>{error}. Confirme se a API está rodando em http://localhost:8000.</p></div></Shell>;
  if (!simulation) return <Shell><div className="sim-loading">Carregando questões do banco...</div></Shell>;
  if (screen === "welcome") return <Shell><Welcome simulation={simulation} onStart={start} /></Shell>;
  if (screen === "results") return <Shell><Results score={score} total={simulation.questions.length} onReview={() => setScreen("review")} onRestart={start} /></Shell>;
  if (screen === "review") return <Shell><Review simulation={simulation} answers={answers} score={score} onBack={() => setScreen("results")} /></Shell>;
  return <Shell><Exam simulation={simulation} question={question} current={current} answers={answers} answeredCount={answeredCount} seconds={seconds} hintOpen={hintOpen} setHintOpen={setHintOpen} selectAnswer={selectAnswer} previous={previous} next={next} setCurrent={setCurrent} formatTime={formatTime} /></Shell>;
}

function Shell({ children }) { return <div className="simulator-shell"><header className="sim-header"><div className="sim-brand"><span className="sim-logo"><BookOpen size={20} /></span><div><strong>SIMULADO SAEP 2026</strong><small>Técnico em Desenvolvimento de Sistemas · SENAI-SP</small></div></div></header><main className="sim-main">{children}</main><footer className="sim-footer">Banco de questões · ambiente de prática</footer></div>; }
function Welcome({ simulation, onStart }) { return <section className="welcome-card"><div className="welcome-hero"><p className="sim-eyebrow">Avaliação diagnóstica</p><h1>Pronto para testar<br /><em>seu conhecimento?</em></h1><p>Uma sessão objetiva para revisar conceitos de programação e desenvolvimento de sistemas. As questões são carregadas diretamente do banco oficial.</p><button className="sim-primary" onClick={onStart}>Iniciar simulado <ArrowRight size={17} /></button></div><div className="welcome-info"><div><ListChecks size={21} /><strong>{simulation.question_count} questões</strong><span>selecionadas para esta sessão</span></div><div><Clock3 size={21} /><strong>{simulation.duration_minutes} minutos</strong><span>tempo recomendado</span></div><div><Award size={21} /><strong>Resultado detalhado</strong><span>revise seus acertos depois</span></div></div></section>; }
function Exam({ simulation, question, current, answers, answeredCount, seconds, hintOpen, setHintOpen, selectAnswer, previous, next, setCurrent, formatTime }) { return <section className="exam-layout"><div className="exam-topline"><div><p className="sim-eyebrow">{simulation.title}</p><strong>Questão {current + 1} <span>de {simulation.questions.length}</span></strong></div><div className="exam-stats"><span><Clock3 size={16} /> {formatTime(seconds)}</span><span><ListChecks size={16} /> {answeredCount}/{simulation.questions.length}</span></div></div><div className="exam-progress"><i style={{ width: `${((current + 1) / simulation.questions.length) * 100}%` }} /></div><article className="exam-card"><div className="question-label">QUESTÃO {String(question.position).padStart(2, "0")}</div><h1>{question.statement}</h1><div className="answers">{question.options.map((option) => <button className={`answer ${answers[question.id] === option.position ? "selected" : ""}`} key={option.position} onClick={() => selectAnswer(option.position)}><span className="answer-letter">{LETTERS[option.position - 1]}</span><span>{option.content}</span>{answers[question.id] === option.position && <Check className="answer-check" size={17} />}</button>)}</div><button className="hint-button" onClick={() => setHintOpen((value) => !value)}><Lightbulb size={16} /> {hintOpen ? "Ocultar dica" : "Mostrar dica"}</button>{hintOpen && <div className="hint-box">Dica: releia o enunciado e elimine primeiro as alternativas que não respondem diretamente ao problema.</div>}</article><div className="exam-navigation"><button className="sim-secondary" onClick={previous} disabled={current === 0}><ChevronLeft size={17} /> Anterior</button><div className="palette">{simulation.questions.map((item, index) => <button className={`${index === current ? "current" : ""} ${answers[item.id] ? "answered" : ""}`} key={item.id} onClick={() => setCurrent(index)}>{index + 1}</button>)}</div><button className="sim-primary" onClick={next}>{current === simulation.questions.length - 1 ? "Finalizar" : "Próxima"} <ChevronRight size={17} /></button></div></section>; }
function Results({ score, total, onReview, onRestart }) { const percentage = Math.round((score / total) * 100); return <section className="result-card"><div className="result-icon"><Award size={30} /></div><p className="sim-eyebrow">Sessão concluída</p><h1>Seu resultado</h1><div className="score-display"><strong>{score}<small>/{total}</small></strong><span>{percentage}% de aproveitamento</span></div><p className="result-message">{percentage >= 70 ? "Bom trabalho. Você está construindo uma base consistente." : "Continue praticando. Cada revisão deixa seu raciocínio mais afiado."}</p><div className="result-actions"><button className="sim-primary" onClick={onReview}><ListChecks size={17} /> Revisar respostas</button><button className="sim-secondary" onClick={onRestart}><RotateCcw size={17} /> Refazer simulado</button></div></section>; }
function Review({ simulation, answers, score, onBack }) { return <section className="review-layout"><div className="review-heading"><button className="back-link" onClick={onBack}><ArrowLeft size={16} /> Voltar ao resultado</button><p className="sim-eyebrow">Revisão detalhada · {score}/{simulation.questions.length}</p><h1>Veja como você respondeu</h1></div><div className="review-list">{simulation.questions.map((question, index) => <article className="review-item" key={question.id}><div className="review-number">{String(index + 1).padStart(2, "0")}</div><div><h2>{question.statement}</h2><p className={answers[question.id] ? "review-answer" : "review-unanswered"}>{answers[question.id] ? `Você marcou a alternativa ${LETTERS[answers[question.id] - 1]}.` : "Questão não respondida."}</p></div></article>)}</div></section>; }
