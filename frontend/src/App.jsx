import { useEffect, useState } from "react";
import { ArrowUpRight, BookOpen, BrainCircuit, Check, ChevronLeft, ChevronRight, ClipboardList, Database, FileQuestion, LayoutDashboard, Menu, Search, SlidersHorizontal, Sparkles, X } from "lucide-react";
import { getQuestions, getSimulations, getSubjects } from "./api";

const navItems = [
  { id: "overview", label: "Visão geral", icon: LayoutDashboard },
  { id: "questions", label: "Banco de questões", icon: FileQuestion },
  { id: "simulations", label: "Simulados", icon: ClipboardList },
];
const difficultyLabels = { easy: "Fácil", medium: "Médio", hard: "Difícil" };

export default function App() {
  const [activeView, setActiveView] = useState("overview");
  const [mobileNav, setMobileNav] = useState(false);
  const [subjects, setSubjects] = useState([]);
  const [simulations, setSimulations] = useState([]);
  const [questions, setQuestions] = useState({ items: [], total: 0, pages: 0, page: 1 });
  const [filters, setFilters] = useState({ search: "", subjectId: "", difficulty: "" });
  const [page, setPage] = useState(1);
  const [selectedQuestion, setSelectedQuestion] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    Promise.all([getSubjects(), getSimulations()]).then(([subjectData, simulationData]) => {
      setSubjects(subjectData); setSimulations(simulationData);
    }).catch((requestError) => setError(requestError.message));
  }, []);
  useEffect(() => {
    setLoading(true);
    const timer = setTimeout(() => getQuestions({ ...filters, page }).then(setQuestions)
      .catch((requestError) => setError(requestError.message)).finally(() => setLoading(false)), 180);
    return () => clearTimeout(timer);
  }, [filters, page]);
  const navigate = (view) => { setActiveView(view); setMobileNav(false); };
  const updateFilter = (key, value) => { setPage(1); setFilters((current) => ({ ...current, [key]: value })); };

  return <div className="app-shell">
    <aside className={`sidebar ${mobileNav ? "sidebar-open" : ""}`}>
      <div className="brand"><div className="brand-mark"><BrainCircuit size={21} /></div><div><strong>questão.</strong><span>acervo de estudo</span></div></div>
      <div className="workspace-label">Área de trabalho</div>
      <nav className="nav-list">{navItems.map(({ id, label, icon: Icon }) => <button className={`nav-item ${activeView === id ? "active" : ""}`} key={id} onClick={() => navigate(id)}><Icon size={18} /><span>{label}</span>{id === "questions" && <span className="nav-count">60</span>}</button>)}</nav>
      <div className="sidebar-bottom"><div className="sync-status"><span className="status-dot" /> API conectada</div><div className="profile"><div className="avatar">AE</div><div><strong>Ana Editora</strong><span>Editor do acervo</span></div><span className="more-dots">•••</span></div></div>
    </aside>
    {mobileNav && <button className="backdrop" aria-label="Fechar menu" onClick={() => setMobileNav(false)} />}
    <main className="main-content">
      <header className="topbar"><button className="icon-button mobile-menu" onClick={() => setMobileNav(true)} aria-label="Abrir menu"><Menu size={20} /></button><div className="breadcrumb"><span>Workspace</span><ChevronRight size={14} /><strong>{navItems.find((item) => item.id === activeView)?.label}</strong></div><button className="outline-button" onClick={() => navigate("questions")}><Sparkles size={16} /> Nova questão</button></header>
      {error && <div className="error-banner"><X size={16} /> Não foi possível conectar à API. Verifique se o backend está em execução.</div>}
      {activeView === "overview" && <Overview questions={questions} subjects={subjects} simulations={simulations} onNavigate={navigate} />}
      {activeView === "questions" && <QuestionsView questions={questions} subjects={subjects} filters={filters} loading={loading} page={page} setPage={setPage} updateFilter={updateFilter} onSelect={setSelectedQuestion} />}
      {activeView === "simulations" && <SimulationsView simulations={simulations} onNavigate={navigate} />}
    </main>
    {selectedQuestion && <QuestionModal question={selectedQuestion} onClose={() => setSelectedQuestion(null)} />}
  </div>;
}

function Overview({ questions, subjects, simulations, onNavigate }) { return <section className="page fade-in"><div className="page-intro"><div><p className="eyebrow">Segunda-feira, 14 de setembro</p><h1>Seu acervo, <em>em movimento.</em></h1><p className="intro-copy">Organize conhecimento, crie bons simulados e acompanhe o que realmente precisa ser estudado.</p></div><button className="primary-button" onClick={() => onNavigate("questions")}><BookOpen size={17} /> Explorar questões</button></div><div className="stat-grid"><StatCard icon={FileQuestion} label="Questões publicadas" value={questions.total || "—"} detail="disponíveis no acervo" tone="green" /><StatCard icon={Database} label="Assuntos catalogados" value={subjects.length || "—"} detail="organizados por tema" tone="yellow" /><StatCard icon={ClipboardList} label="Simulados ativos" value={simulations.length || "—"} detail="prontos para aplicação" tone="blue" /></div><div className="overview-grid"><section className="panel focus-panel"><div className="panel-heading"><div><p className="eyebrow">Atalho de estudo</p><h2>Continue de onde parou</h2></div><ArrowUpRight size={19} /></div><div className="focus-body"><div className="focus-icon"><BrainCircuit size={27} /></div><div><strong>Diagnóstico de Banco de Dados e Lógica</strong><p>3 questões · 30 minutos</p><div className="progress-track"><span style={{ width: "66%" }} /></div><small>2 de 3 questões respondidas</small></div><button className="text-button" onClick={() => onNavigate("simulations")}>Retomar <ArrowUpRight size={15} /></button></div></section><section className="panel subject-panel"><div className="panel-heading"><div><p className="eyebrow">Cobertura</p><h2>Seus assuntos</h2></div><button className="link-button" onClick={() => onNavigate("questions")}>Ver acervo</button></div><div className="subject-list">{subjects.slice(0, 5).map((subject) => <div className="subject-row" key={subject.id}><span>{subject.name}</span><span className="subject-line"><i /></span><small>tema</small></div>)}</div></section></div></section>; }
function StatCard({ icon: Icon, label, value, detail, tone }) { return <div className={`stat-card ${tone}`}><div className="stat-icon"><Icon size={20} /></div><div><span>{label}</span><strong>{value}</strong><small>{detail}</small></div></div>; }
function QuestionsView({ questions, subjects, filters, loading, page, setPage, updateFilter, onSelect }) { return <section className="page fade-in"><div className="page-title-row"><div><p className="eyebrow">Acervo completo</p><h1>Banco de questões</h1><p className="intro-copy">Encontre, revise e organize questões para transformar conteúdo em prática.</p></div><div className="question-total"><strong>{questions.total}</strong><span>questões encontradas</span></div></div><div className="toolbar"><div className="search-field"><Search size={18} /><input value={filters.search} onChange={(event) => updateFilter("search", event.target.value)} placeholder="Buscar no enunciado..." /></div><select value={filters.subjectId} onChange={(event) => updateFilter("subjectId", event.target.value)}><option value="">Todos os assuntos</option>{subjects.map((subject) => <option value={subject.id} key={subject.id}>{subject.name}</option>)}</select><select value={filters.difficulty} onChange={(event) => updateFilter("difficulty", event.target.value)}><option value="">Todas as dificuldades</option><option value="easy">Fácil</option><option value="medium">Médio</option><option value="hard">Difícil</option></select><button className="filter-button" onClick={() => { updateFilter("search", ""); updateFilter("subjectId", ""); updateFilter("difficulty", ""); }}><SlidersHorizontal size={16} /> Limpar</button></div><div className="panel question-panel"><div className="table-head"><span>Questão</span><span>Assunto</span><span>Dificuldade</span><span>Status</span></div>{loading ? <div className="loading-state">Consultando o acervo...</div> : questions.items.map((question) => <button className="question-row" key={question.id} onClick={() => onSelect(question)}><span className="question-cell"><b>#{String(question.id).padStart(3, "0")}</b><strong>{question.statement}</strong><small>{question.source.name}</small></span><span className="subject-chip">{question.subjects[0]?.name || "Sem assunto"}</span><span><span className={`difficulty ${question.difficulty}`}>{difficultyLabels[question.difficulty]}</span></span><span><span className="published"><Check size={13} /> Publicada</span></span></button>)}{!loading && !questions.items.length && <div className="empty-state">Nenhuma questão corresponde aos filtros.</div>}<div className="pagination"><span>Página {questions.page} de {Math.max(questions.pages, 1)}</span><div><button className="icon-button" disabled={page <= 1} onClick={() => setPage(page - 1)} aria-label="Página anterior"><ChevronLeft size={17} /></button><button className="icon-button" disabled={page >= questions.pages} onClick={() => setPage(page + 1)} aria-label="Próxima página"><ChevronRight size={17} /></button></div></div></div></section>; }
function SimulationsView({ simulations, onNavigate }) { return <section className="page fade-in"><div className="page-title-row"><div><p className="eyebrow">Prática guiada</p><h1>Simulados</h1><p className="intro-copy">Monte uma prova por assunto ou retome uma aplicação em andamento.</p></div><button className="primary-button" onClick={() => onNavigate("questions")}><Sparkles size={17} /> Criar simulado</button></div><div className="simulation-grid">{simulations.map((simulation) => <article className="simulation-card" key={simulation.id}><div className="simulation-kicker"><ClipboardList size={16} /> SIMULADO PUBLICADO</div><h2>{simulation.title}</h2><p>{simulation.question_count} questões selecionadas para uma sessão objetiva de revisão.</p><div className="simulation-meta"><span>{simulation.duration_minutes} min</span><span>•</span><span>{simulation.question_count} questões</span></div><button className="primary-button full-button" onClick={() => { window.location.href = `/simulador.html?simulation_id=${simulation.id}`; }}>Iniciar simulado <ArrowUpRight size={16} /></button></article>)}{!simulations.length && <div className="empty-state">Nenhum simulado publicado.</div>}</div></section>; }
function QuestionModal({ question, onClose }) { return <div className="modal-layer" onClick={onClose}><div className="question-modal" onClick={(event) => event.stopPropagation()}><button className="modal-close" onClick={onClose} aria-label="Fechar"><X size={19} /></button><div className="modal-meta"><span>Questão #{String(question.id).padStart(3, "0")}</span><span className={`difficulty ${question.difficulty}`}>{difficultyLabels[question.difficulty]}</span></div><h2>{question.statement}</h2><div className="modal-options">{question.options.map((option) => <div className="modal-option" key={option.id}><span>{String.fromCharCode(64 + option.position)}</span>{option.content}</div>)}</div><div className="modal-footer"><span>{question.source.name}</span><span>{question.subjects.map((subject) => subject.name).join(" · ")}</span></div></div></div>; }
