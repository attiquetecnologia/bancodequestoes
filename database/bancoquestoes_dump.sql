PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE app_user (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE COLLATE NOCASE,
    role TEXT NOT NULL CHECK (role IN ('admin', 'editor', 'student')),
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO app_user VALUES(1,'Administrador do Banco','admin@bancoquestoes.local','admin','active','2026-09-14 13:44:37');
INSERT INTO app_user VALUES(2,'Ana Editora','ana.editor@bancoquestoes.local','editor','active','2026-09-14 13:44:37');
INSERT INTO app_user VALUES(3,'Carlos Estudante','carlos.aluno@bancoquestoes.local','student','active','2026-09-14 13:44:37');
CREATE TABLE source (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    institution TEXT,
    year INTEGER CHECK (year IS NULL OR year BETWEEN 1900 AND 2100),
    reference_url TEXT,
    usage_status TEXT NOT NULL DEFAULT 'own'
        CHECK (usage_status IN ('own', 'licensed', 'reference_only')),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO source VALUES(1,'Autoria própria','Banco de Questões',2026,NULL,'own','2026-09-14 13:44:37');
INSERT INTO source VALUES(2,'Prova de Tecnologia da Informação','Exemplo Educacional',2025,NULL,'reference_only','2026-09-14 13:44:37');
INSERT INTO source VALUES(3,'Simulador SAEP 2026','SENAI-SP',2026,NULL,'reference_only','2026-09-14 13:51:54');
CREATE TABLE subject (
    id INTEGER PRIMARY KEY,
    parent_id INTEGER REFERENCES subject(id) ON DELETE RESTRICT,
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (parent_id, name)
);
INSERT INTO subject VALUES(1,NULL,'Tecnologia','tecnologia','2026-09-14 13:44:37');
INSERT INTO subject VALUES(2,1,'Banco de Dados','tecnologia-banco-de-dados','2026-09-14 13:44:37');
INSERT INTO subject VALUES(3,2,'SQL','tecnologia-banco-de-dados-sql','2026-09-14 13:44:37');
INSERT INTO subject VALUES(4,2,'Modelagem Relacional','tecnologia-banco-de-dados-modelagem','2026-09-14 13:44:37');
INSERT INTO subject VALUES(5,1,'Lógica de Programação','tecnologia-logica-de-programacao','2026-09-14 13:44:37');
INSERT INTO subject VALUES(6,1,'Lógica de Programação e Algoritmos','tecnologia-logica-de-programacao-e-algoritmos','2026-09-14 13:51:54');
INSERT INTO subject VALUES(7,1,'Levantamento de Requisitos','tecnologia-levantamento-de-requisitos','2026-09-14 13:51:54');
INSERT INTO subject VALUES(8,1,'Arquitetura de Redes com IoT','tecnologia-arquitetura-de-redes-com-iot','2026-09-14 13:51:54');
INSERT INTO subject VALUES(9,1,'Sistemas Operacionais','tecnologia-sistemas-operacionais','2026-09-14 13:51:54');
INSERT INTO subject VALUES(10,1,'Linguagem de Marcação','tecnologia-linguagem-de-marcacao','2026-09-14 13:51:54');
INSERT INTO subject VALUES(11,1,'Programação Front-End','tecnologia-programacao-front-end','2026-09-14 13:51:54');
INSERT INTO subject VALUES(12,1,'Programação Back-End','tecnologia-programacao-back-end','2026-09-14 13:51:54');
INSERT INTO subject VALUES(13,1,'Programação para Dispositivos Móveis','tecnologia-programacao-para-dispositivos-moveis','2026-09-14 13:51:54');
INSERT INTO subject VALUES(14,1,'Teste de Software','tecnologia-teste-de-software','2026-09-14 13:51:54');
INSERT INTO subject VALUES(15,1,'Internet das Coisas (IoT)','tecnologia-internet-das-coisas-iot','2026-09-14 13:51:54');
INSERT INTO subject VALUES(16,1,'Projetos de Software','tecnologia-projetos-de-software','2026-09-14 13:51:54');
CREATE TABLE question (
    id INTEGER PRIMARY KEY,
    source_id INTEGER NOT NULL REFERENCES source(id) ON DELETE RESTRICT,
    author_id INTEGER NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
    statement TEXT NOT NULL CHECK (length(trim(statement)) >= 10),
    explanation TEXT,
    hint TEXT,
    question_type TEXT NOT NULL DEFAULT 'single_choice'
        CHECK (question_type = 'single_choice'),
    difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard')),
    status TEXT NOT NULL DEFAULT 'draft'
        CHECK (status IN ('draft', 'published', 'archived')),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO question VALUES(1,3,2,'Em um algoritmo, qual estrutura de controle é mais adequada para executar um conjunto de instruções um número determinado de vezes, utilizando uma variável de contagem?','O laço for é ideal para repetições controladas por contador com limite definido.','Pense na estrutura que possui inicialização, condição e incremento explícitos.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(2,3,2,'Qual operador lógico retorna verdadeiro (true) se e somente se AMBAS as condições avaliadas forem verdadeiras?','O operador E (AND) exige que todas as expressões booleanas sejam verdadeiras para o resultado ser verdadeiro.','É representado na programação por símbolos como ''&&''.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(3,3,2,'O que caracteriza a adoção de técnicas de código limpo (Clean Code) no desenvolvimento de software?','Código limpo prioriza a clareza, legibilidade e facilidade de manutenção por outros desenvolvedores.','O código deve ser fácil de ser lido e compreendido por humanos.','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(4,3,2,'No contexto do Git (sistema de controle de versão distribuído), qual comando é utilizado para registrar as alterações efetivadas no repositório local?','O commit consolida e registra as alterações preparadas (staging area) no histórico local.','É o comando que cria um ponto de salvamento oficial no histórico com mensagem descritiva.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(5,3,2,'Em linguagens de programação, qual é a principal diferença entre variáveis e constantes?','Constantes protegem valores que não devem sofrer modificações ao longo da execução.','Pense no significado literal dos termos: mudar versus manter constante.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(6,3,2,'O que representa uma matriz em programação estruturada?','Matrizes são arranjos multidimensionais (geralmente 2D) organizados em linhas e colunas.','Imagine uma tabela com células indexadas por dois índices: [linha][coluna].','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(7,3,2,'Qual plataforma de versionamento em nuvem utiliza o conceito de ''Pull Requests'' para propor e revisar alterações de código em equipes?','GitHub popularizou o fluxo de Pull Requests para revisão de código colaborativo.','É uma das plataformas mais populares do mundo hospedada pela Microsoft.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(8,3,2,'Qual é a finalidade principal de um fluxograma na elaboração de algoritmos?','Fluxogramas usam símbolos padronizados para ilustrar visualmente a lógica do algoritmo.','Utiliza símbolos geométricos conectados por setas.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(9,3,2,'Qual é a principal distinção entre requisitos funcionais e não funcionais em um sistema?','Funcionais definem funcionalidades; não funcionais definem atributos como velocidade, segurança e usabilidade.','Pense na diferença entre ''o que o sistema faz'' versus ''como o sistema deve se comportar''.','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(10,3,2,'Na metodologia ágil Scrum, qual papel é o principal responsável por gerenciar o Product Backlog e priorizar os itens de acordo com o valor de negócio?','O PO representa o cliente/negócio e define a prioridade do backlog.','É a voz do cliente junto ao time de desenvolvimento.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(11,3,2,'Quais são as etapas fundamentais que compõem o processo do Design Thinking?','Estas são as fases clássicas do processo de Design Thinking centrado no usuário.','Começa compreendendo profundamente as pessoas e passa por ideação e protótipos.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(12,3,2,'O que é um quadro Kanban e qual sua utilidade na gestão de projetos?','Kanban visualiza o trabalho em andamento para otimizar o fluxo e evitar gargalos.','Utiliza cartões visuais movidos entre colunas de status.','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(13,3,2,'Qual técnica de levantamento de requisitos envolve a observação direta dos usuários executando suas tarefas no ambiente real de trabalho?','A etnografia observa o usuário no seu ambiente natural para capturar necessidades implícitas.','Técnica oriunda da antropologia aplicada à engenharia de software.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(14,3,2,'O que define uma Regra de Negócio durante a elicitação de requisitos?','Regras de negócio traduzem a lógica operacional e as políticas da empresa.','Exemplo: ''Clientes ouro possuem 10% de desconto automático no frete''.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(15,3,2,'Qual é o objetivo do documento de Briefing no início de um projeto de software?','Briefing é o resumo inicial das necessidades e escopo trazido pelo cliente.','É a conversa ou questionário inicial com o cliente.','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(16,3,2,'Qual protocolo leve de mensagens baseado em publicação/assinatura (Pub/Sub) é amplamente utilizado em dispositivos IoT e automação industrial?','MQTT é otimizado para redes instáveis e dispositivos com baixo consumo de energia.','Utiliza brokers, tópicos e clientes que publicam ou subscrevem.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(17,3,2,'O que caracteriza uma topologia de rede em Malha (Mesh)?','Na topologia mesh, os nós conectam-se diretamente a múltiplos vizinhos.','Oferece rotas alternativas caso um dos caminhos caia.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(18,3,2,'No endereçamento IPv4, quantos bits compõem o endereço IP completo?','IPv4 possui 32 bits divididos em 4 octetos.','Exemplo: 192.168.1.1 (4 blocos de 8 bits).','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(19,3,2,'Qual dispositivo de rede atua na camada de rede (Camada 3 do OSI) encaminhando pacotes entre redes distintas?','Roteadores utilizam endereços IP para interligar redes e direcionar pacotes.','É o equipamento que conecta sua casa à internet através da operadora.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(20,3,2,'O que significam os componentes de I/O (Inputs e Outputs) na arquitetura de hardware voltada para IoT?','I/O permite que microcontroladores leiam sensores e acionem atuadores físicos.','Entradas coletam dados do ambiente; saídas realizam ações no ambiente.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(21,3,2,'Qual porta padrão é utilizada pelo protocolo HTTPS para requisições web seguras?','Porta 443 é o padrão dedicado ao tráfego HTTP criptografado (TLS/SSL).','É a porta que garante o cadeado verde no navegador.','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(22,3,2,'Em arquiteturas de rede, o que caracteriza o modelo Cliente-Servidor?','O servidor centraliza dados/serviços e atende às requisições dos clientes.','Pense em um navegador acessando uma aplicação web hospedada em um servidor.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(23,3,2,'No sistema operacional Linux (código aberto), qual comando em modo texto é utilizado para navegar entre diretórios?','O comando ''cd'' (change directory) altera o diretório de trabalho atual.','Abreviação de ''change directory''.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(24,3,2,'Qual é a principal função de um Firewall nativo em um sistema operacional?','Firewalls protegem o sistema bloqueando acessos indesejados ou maliciosos.','Atua como uma ''parede de fogo'' controlando portas e conexões de rede.','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(25,3,2,'O que estabelece a Lei Geral de Proteção de Dados (LGPD - Lei nº 13.709/2018) no Brasil?','A LGPD protege os direitos fundamentais de privacidade e proteção de dados dos cidadãos.','Garante consentimento e transparência no uso de dados pessoais.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(26,3,2,'O que é uma VPN (Virtual Private Network) utilizada em sistemas operacionais e redes?','VPN garante confidencialidade e integridade no tráfego remoto de dados.','Muito utilizada para trabalho remoto seguro (home office).','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(27,3,2,'Qual comando Linux é utilizado para criar um novo diretório (pasta)?','Abreviação de ''make directory''.','Make directory.','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(28,3,2,'O que caracteriza um ataque de Engenharia Social no contexto da segurança cibernética?','Engenharia social explora a vulnerabilidade humana (ex: phishing).','Engana a pessoa, e não a máquina.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(29,3,2,'Qual é a finalidade do arquivo /etc/passwd ou gerenciamento de usuários em sistemas operacionais Unix/Linux?','Contém informações das contas de usuário cadastradas no sistema.','Contém a listagem dos usuários cadastrados.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(30,3,2,'O que aborda o Marco Civil da Internet (Lei nº 12.965/2014) no Brasil?','O Marco Civil estabelece as bases legais e direitos dos usuários na rede.','Consagra a neutralidade da rede e a privacidade dos usuários.','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(31,3,2,'Qual comando SQL pertence à DDL (Data Definition Language) e é utilizado para criar uma nova tabela no banco de dados?','CREATE TABLE define a estrutura da tabela no banco de dados.','Comando para estruturar e definir o esquema.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(32,3,2,'Qual cláusula SQL é utilizada para filtrar registros retornados por uma consulta com base em condições específicas?','A cláusula WHERE filtra linhas de acordo com critérios lógicos.','Significa ''onde'' em inglês.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(33,3,2,'O que realiza uma operação de INNER JOIN entre duas tabelas?','INNER JOIN faz a junção cruzando apenas os dados que casam nas duas tabelas.','Exibe somente a intersecção entre as tabelas relacionadas.','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(34,3,2,'Qual é o principal objetivo da Normalização de Banco de Dados?','As formas normais garantem integridade estrutural e eliminam redundâncias desnecessárias.','Evita duplicação desnecessária de informações.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(35,3,2,'O que é uma Stored Procedure (Procedimento Armazenado) em um SGBD?','Stored procedures encapsulam lógica de programação reutilizável diretamente no SGBD.','Rotina procedural armazenada diretamente no banco.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(36,3,2,'Qual comando SQL é utilizado para remover registros existentes de uma tabela?','DELETE remove linhas específicas de uma tabela com base em critérios.','Remove linhas, mantendo a estrutura da tabela intacta.','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(37,3,2,'O que representa o Modelo Entidade-Relacionamento (MER) e seu respectivo Diagrama (DER)?','MER/DER modelam o domínio de dados antes da implementação física.','Diagrama com retângulos, losangos e linhas representando o banco.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(38,3,2,'Para que serve a função de agregação COUNT() em consultas SQL?','COUNT retorna a contagem de registros resultantes.','Conta a quantidade de ocorrências.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(39,3,2,'Qual tag HTML5 é semanticamente mais adequada para representar o cabeçalho principal de uma página ou seção?','A tag semântica <header> representa conteúdo introdutório ou grupo de links de navegação.','Significa cabeçalho em inglês.','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(40,3,2,'Em formulários HTML, qual atributo do elemento `<input>` define o tipo de dado esperado (ex: texto, senha, e-mail, número)?','O atributo ''type'' especifica o comportamento e o formato de entrada do input (ex: type=''password'').','Define se o campo aceita texto livre, senha mascarada ou e-mail.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(41,3,2,'O que significa a sigla HTML?','Linguagem de Marcação de Hipertexto é a linguagem padrão para criação de páginas web.','Linguagem de marcação para páginas web baseadas em hipertexto.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(42,3,2,'Como se representa uma cor utilizando o formato RGB em estilização ou atributos web?','Define valores de Intensidade para Vermelho, Verde e Azul de 0 a 255.','Combinação de Red, Green e Blue com valores numéricos.','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(43,3,2,'Qual elemento HTML é utilizado para criar uma lista não ordenada (com marcadores em formato de pontos)?','<ul> (Unordered List) cria listas com marcadores em bullet points.','Unordered list.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(44,3,2,'Qual é a utilidade do elemento `<meta charset="UTF-8">` no cabeçalho de um documento HTML?','UTF-8 garante a exibição correta de acentos e caracteres especiais.','Garante que acentos (ç, á, ã) apareçam corretamente na tela.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(45,3,2,'Em JavaScript, qual método ou forma é recomendada para selecionar um elemento HTML pelo seu atributo ID no DOM?','getElementById é o método tradicional e direto para buscar elementos únicos por ID.','Get element by id.','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(46,3,2,'O que é o DOM (Document Object Model) em aplicações web Front-End?','O DOM conecta páginas web a scripts, permitindo manipulação dinâmica de elementos, atributos e estilos.','Representação em árvore dos elementos HTML na memória do navegador.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(47,3,2,'Qual seletor CSS é utilizado para aplicar estilos a um elemento específico que possui o atributo `id="cabecalho"`?','O caractere cerquilha (#) é o seletor padrão para IDs em CSS.','Usa o símbolo de sustenido/jogo da velha (#).','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(48,3,2,'Em JavaScript moderno (ES6+), qual palavra-chave é utilizada para declarar uma variável escopada ao bloco cujo valor pode ser reatribuído?','''let'' declara variáveis com escopo de bloco e reatribuíveis.','Substituiu amplamente o ''var'' com escopo de bloco.','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(49,3,2,'Qual propriedade do CSS Flexbox define o alinhamento dos itens ao longo do eixo principal (main axis)?','justify-content gerencia a distribuição e alinhamento no eixo principal.','Justifica o conteúdo horizontalmente ou verticalmente no eixo principal.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(50,3,2,'Como se adiciona um evento de clique a um botão utilizando JavaScript?','addEventListener é a forma padrão e moderna de registrar ouvintes de eventos.','Adicionar ouvinte de evento.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(51,3,2,'No desenvolvimento Back-End com Node.js e Express, o que representa um ''Middleware''?','Middlewares interceptam requisições para executar validações, autenticações ou logs.','Fica no ''meio'' do caminho entre a requisição HTTP e a resposta final.','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(52,3,2,'O que caracteriza uma API RESTful em arquiteturas Back-End?','RESTful padroniza a comunicação web baseada em recursos e verbos HTTP.','Utiliza métodos como GET para buscar e POST para criar.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(53,3,2,'Qual é a função do npm (Node Package Manager) no ecossistema de desenvolvimento JavaScript?','npm é o gerenciador de pacotes padrão para instalar e compartilhar módulos.','Gerenciador de pacotes do ecosistema Node.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(54,3,2,'O que significa dizer que o Node.js possui arquitetura assíncrona e orientada a eventos com single-thread?','O event loop permite alta concorrência sem criar uma nova thread para cada requisição.','Utiliza o famoso Event Loop para lidar com chamadas assíncronas.','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(55,3,2,'O que caracteriza frameworks de desenvolvimento mobile multiplataforma (Cross-Platform) como Flutter ou React Native?','Frameworks cross-platform otimizam o tempo de desenvolvimento gerando apps nativos para várias plataformas.','Escreve uma única vez e compila para Android e iOS.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(56,3,2,'No ciclo de vida de uma tela ou Activity em desenvolvimento mobile, qual método é executado quando a tela se torna visível para o usuário?','onResume indica que a aplicação ganhou foco e está interagindo com o usuário.','Retoma a interação com o usuário.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(57,3,2,'O que são Testes Unitários no processo de desenvolvimento de software?','Testes unitários garantem que componentes individuais operem conforme especificado.','Focam na menor parte testável do código, como funções isoladas.','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(58,3,2,'Qual é a principal diferença entre testes funcionais (caixa preta) e testes estruturais (caixa branca)?','Caixa preta valida o ''o que faz'' externamente; caixa branca valida o ''como é feito'' no código.','Preta: sem ver o código. Branca: olhando diretamente o código fonte.','single_choice','medium','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(59,3,2,'Qual é o papel de uma placa microcontrolada (como ESP32 ou Arduino) em um projeto de Internet das Coisas (IoT)?','Microcontroladores fazem a ponte entre o mundo físico e a nuvem/rede IoT.','Cérebro eletrônico embarcado com pinos GPIO para sensores e atuadores.','single_choice','easy','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
INSERT INTO question VALUES(60,3,2,'No encerramento e entrega de um projeto de software integrando todas as UCs do curso técnico, por que a documentação técnica e o treinamento do usuário final são fundamentais?','Documentação e treinamento asseguram a transição bem-sucedida, suporte e sustentabilidade do software.','Garante que o cliente saiba operar o sistema e que futuros devs possam dar manutenção.','single_choice','hard','published','2026-09-14 15:07:41','2026-09-14 15:07:41');
CREATE TABLE option_item (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL REFERENCES question(id) ON DELETE CASCADE,
    position INTEGER NOT NULL CHECK (position BETWEEN 1 AND 5),
    content TEXT NOT NULL CHECK (length(trim(content)) >= 1),
    is_correct INTEGER NOT NULL DEFAULT 0 CHECK (is_correct IN (0, 1)),
    UNIQUE (question_id, position)
);
INSERT INTO option_item VALUES(1,1,1,'Estrutura condicional simples (if)',0);
INSERT INTO option_item VALUES(2,1,2,'Laço de repetição com contador (for)',1);
INSERT INTO option_item VALUES(3,1,3,'Estrutura de seleção múltipla (switch)',0);
INSERT INTO option_item VALUES(4,1,4,'Laço condicional pré-testado (while)',0);
INSERT INTO option_item VALUES(5,2,1,'E (AND)',1);
INSERT INTO option_item VALUES(6,2,2,'OU (OR)',0);
INSERT INTO option_item VALUES(7,2,3,'NÃO (NOT)',0);
INSERT INTO option_item VALUES(8,2,4,'OU Exclusivo (XOR)',0);
INSERT INTO option_item VALUES(9,3,1,'Abreviar ao máximo os nomes de variáveis para economizar memória do computador.',0);
INSERT INTO option_item VALUES(10,3,2,'Escrever códigos legíveis, fáceis de manter, com nomes significativos e funções coesas.',1);
INSERT INTO option_item VALUES(11,3,3,'Eliminar completamente a necessidade de comentários e documentação em qualquer projeto.',0);
INSERT INTO option_item VALUES(12,3,4,'Utilizar exclusivamente paradigmas de programação de baixo nível.',0);
INSERT INTO option_item VALUES(13,4,1,'git clone',0);
INSERT INTO option_item VALUES(14,4,2,'git push',0);
INSERT INTO option_item VALUES(15,4,3,'git commit',1);
INSERT INTO option_item VALUES(16,4,4,'git init',0);
INSERT INTO option_item VALUES(17,5,1,'Variáveis armazenam apenas números inteiros, enquanto constantes armazenam textos.',0);
INSERT INTO option_item VALUES(18,5,2,'O valor de uma variável pode ser alterado durante a execução do programa, enquanto o valor de uma constante permanece fixo.',1);
INSERT INTO option_item VALUES(19,5,3,'Constantes ocupam espaço em disco, ao passo que variáveis residem apenas na CPU.',0);
INSERT INTO option_item VALUES(20,5,4,'Variáveis não exigem declaração de tipo prévia em nenhuma linguagem.',0);
INSERT INTO option_item VALUES(21,6,1,'Uma variável simples de armazenamento de caractere único.',0);
INSERT INTO option_item VALUES(22,6,2,'Uma estrutura de dados homogênea bidimensional (linhas e colunas).',1);
INSERT INTO option_item VALUES(23,6,3,'Um comando de repetição condicional aninhado.',0);
INSERT INTO option_item VALUES(24,6,4,'Uma função matemática de criptografia.',0);
INSERT INTO option_item VALUES(25,7,1,'GitHub',1);
INSERT INTO option_item VALUES(26,7,2,'Apache HTTP Server',0);
INSERT INTO option_item VALUES(27,7,3,'MySQL Workbench',0);
INSERT INTO option_item VALUES(28,7,4,'Visual Studio Code',0);
INSERT INTO option_item VALUES(29,8,1,'Compilar código fonte diretamente para linguagem de máquina.',0);
INSERT INTO option_item VALUES(30,8,2,'Representar graficamente a sequência lógica de passos e fluxos de decisão de um processo.',1);
INSERT INTO option_item VALUES(31,8,3,'Configurar endereços IP em redes locais.',0);
INSERT INTO option_item VALUES(32,8,4,'Gerenciar tabelas relacionais em SGBDs.',0);
INSERT INTO option_item VALUES(33,9,1,'Requisitos funcionais tratam de custos financeiros, enquanto os não funcionais tratam de prazos.',0);
INSERT INTO option_item VALUES(34,9,2,'Requisitos funcionais descrevem o que o sistema faz (ações e serviços), e os não funcionais descrevem restrições de qualidade, desempenho e segurança.',1);
INSERT INTO option_item VALUES(35,9,3,'Requisitos funcionais são criados pelo cliente e os não funcionais pelo programador júnior.',0);
INSERT INTO option_item VALUES(36,9,4,'Requisitos não funcionais são opcionais em qualquer projeto ágil.',0);
INSERT INTO option_item VALUES(37,10,1,'Scrum Master',0);
INSERT INTO option_item VALUES(38,10,2,'Product Owner (P.O.)',1);
INSERT INTO option_item VALUES(39,10,3,'Lead Developer',0);
INSERT INTO option_item VALUES(40,10,4,'Quality Assurance (QA)',0);
INSERT INTO option_item VALUES(41,11,1,'Empatia, Ideação, Prototipação, Teste e Implementação.',1);
INSERT INTO option_item VALUES(42,11,2,'Compilação, Teste Unitário, Deploy e Manutenção.',0);
INSERT INTO option_item VALUES(43,11,3,'MER, DER, Normalização e DDL.',0);
INSERT INTO option_item VALUES(44,11,4,'Briefing, Commit, Push e Merge.',0);
INSERT INTO option_item VALUES(45,12,1,'Um software antivírus para proteção de servidores web.',0);
INSERT INTO option_item VALUES(46,12,2,'Uma ferramenta visual de gerenciamento de fluxo de trabalho que categoriza tarefas em colunas como A Fazer, Em Andamento e Concluído.',1);
INSERT INTO option_item VALUES(47,12,3,'Um diagrama de classes em UML.',0);
INSERT INTO option_item VALUES(48,12,4,'Uma linguagem de marcação estruturada.',0);
INSERT INTO option_item VALUES(49,13,1,'Etnografia',1);
INSERT INTO option_item VALUES(50,13,2,'Brainstorming',0);
INSERT INTO option_item VALUES(51,13,3,'Diagrama de Entidade-Relacionamento',0);
INSERT INTO option_item VALUES(52,13,4,'Teste de estresse',0);
INSERT INTO option_item VALUES(53,14,1,'A velocidade da conexão de rede exigida pelo servidor.',0);
INSERT INTO option_item VALUES(54,14,2,'Diretrizes, políticas e restrições operacionais que a organização deve seguir em seus processos.',1);
INSERT INTO option_item VALUES(55,14,3,'O número máximo de linhas de código permitidas por arquivo.',0);
INSERT INTO option_item VALUES(56,14,4,'A versão do SGBD utilizada na produção.',0);
INSERT INTO option_item VALUES(57,15,1,'Descrever detalhadamente o código binário compilado.',0);
INSERT INTO option_item VALUES(58,15,2,'Coletar as necessidades iniciais, expectativas e objetivos do cliente para nortear o projeto.',1);
INSERT INTO option_item VALUES(59,15,3,'Realizar o teste de aceitação final do sistema.',0);
INSERT INTO option_item VALUES(60,15,4,'Configurar o roteador Wi-Fi da empresa.',0);
INSERT INTO option_item VALUES(61,16,1,'HTTP',0);
INSERT INTO option_item VALUES(62,16,2,'MQTT (Message Queuing Telemetry Transport)',1);
INSERT INTO option_item VALUES(63,16,3,'FTP',0);
INSERT INTO option_item VALUES(64,16,4,'RDP',0);
INSERT INTO option_item VALUES(65,17,1,'Todos os nós são conectados a um único cabo central (Barramento).',0);
INSERT INTO option_item VALUES(66,17,2,'Dispositivos possuem múltiplos caminhos de interconexão entre si, oferecendo alta redundância e tolerância a falhas.',1);
INSERT INTO option_item VALUES(67,17,3,'Os computadores formam um círculo fechado onde os dados circulam em um sentido.',0);
INSERT INTO option_item VALUES(68,17,4,'Um nó central (como um switch) conecta todos os demais nós.',0);
INSERT INTO option_item VALUES(69,18,1,'32 bits',1);
INSERT INTO option_item VALUES(70,18,2,'64 bits',0);
INSERT INTO option_item VALUES(71,18,3,'128 bits',0);
INSERT INTO option_item VALUES(72,18,4,'16 bits',0);
INSERT INTO option_item VALUES(73,19,1,'Switch de camada 2',0);
INSERT INTO option_item VALUES(74,19,2,'Roteador',1);
INSERT INTO option_item VALUES(75,19,3,'Hub passivo',0);
INSERT INTO option_item VALUES(76,19,4,'Cabo coaxial',0);
INSERT INTO option_item VALUES(77,20,1,'Interfaces de entrada (sensores, botões) e saída (atuadores, LEDs, motores) para interação com o mundo físico.',1);
INSERT INTO option_item VALUES(78,20,2,'Sistemas operacionais de código fechado para servidores em nuvem.',0);
INSERT INTO option_item VALUES(79,20,3,'Protocolos de criptografia de banco de dados.',0);
INSERT INTO option_item VALUES(80,20,4,'Ferramentas de controle de versão Git.',0);
INSERT INTO option_item VALUES(81,21,1,'Porta 80',0);
INSERT INTO option_item VALUES(82,21,2,'Porta 443',1);
INSERT INTO option_item VALUES(83,21,3,'Porta 21',0);
INSERT INTO option_item VALUES(84,21,4,'Porta 3306',0);
INSERT INTO option_item VALUES(85,22,1,'Todos os computadores possuem exatamente o mesmo nível hierárquico sem servidor central.',0);
INSERT INTO option_item VALUES(86,22,2,'Um ou mais computadores centrais (servidores) fornecem recursos e serviços para os demais computadores (clientes) da rede.',1);
INSERT INTO option_item VALUES(87,22,3,'A comunicação ocorre exclusivamente via rádio frequência sem fio.',0);
INSERT INTO option_item VALUES(88,22,4,'Os dados ficam armazenados de forma descentralizada via blockchain.',0);
INSERT INTO option_item VALUES(89,23,1,'ls',0);
INSERT INTO option_item VALUES(90,23,2,'cd',1);
INSERT INTO option_item VALUES(91,23,3,'mkdir',0);
INSERT INTO option_item VALUES(92,23,4,'rm',0);
INSERT INTO option_item VALUES(93,24,1,'Acelerar a velocidade de download de arquivos grandes.',0);
INSERT INTO option_item VALUES(94,24,2,'Controlar e filtrar o tráfego de rede de entrada e saída com base em regras de segurança pré-estabelecidas.',1);
INSERT INTO option_item VALUES(95,24,3,'Compactar arquivos para economizar espaço em disco.',0);
INSERT INTO option_item VALUES(96,24,4,'Gerenciar permissões de usuários em banco de dados.',0);
INSERT INTO option_item VALUES(97,25,1,'Regras rígidas sobre coleta, armazenamento e tratamento de dados pessoais de indivíduos por organizações públicas e privadas.',1);
INSERT INTO option_item VALUES(98,25,2,'A obrigatoriedade de uso do sistema Linux em órgãos governamentais.',0);
INSERT INTO option_item VALUES(99,25,3,'O marco regulatório para infraestrutura de fibra óptica em zonas rurais.',0);
INSERT INTO option_item VALUES(100,25,4,'A taxação de impostos sobre e-commerces internacionais.',0);
INSERT INTO option_item VALUES(101,26,1,'Um tipo de vírus que rouba senhas de administradores.',0);
INSERT INTO option_item VALUES(102,26,2,'Um túnel criptografado que permite conectar dispositivos com segurança a uma rede privada através de uma rede pública (como a internet).',1);
INSERT INTO option_item VALUES(103,26,3,'Um protocolo de compactação de vídeos em alta definição.',0);
INSERT INTO option_item VALUES(104,26,4,'Uma interface gráfica para gerenciamento de memória RAM.',0);
INSERT INTO option_item VALUES(105,27,1,'touch',0);
INSERT INTO option_item VALUES(106,27,2,'mkdir',1);
INSERT INTO option_item VALUES(107,27,3,'cat',0);
INSERT INTO option_item VALUES(108,27,4,'pwd',0);
INSERT INTO option_item VALUES(109,28,1,'A exploração de falhas em placas de vídeo de alta performance.',0);
INSERT INTO option_item VALUES(110,28,2,'A manipulação psicológica de usuários para induzi-los a revelar informações confidenciais ou senhas.',1);
INSERT INTO option_item VALUES(111,28,3,'Um curto-circuito em servidores de data center.',0);
INSERT INTO option_item VALUES(112,28,4,'A sobrecarga de requisições em um servidor web (DDoS).',0);
INSERT INTO option_item VALUES(113,29,1,'Armazenar logs de conexões Wi-Fi.',0);
INSERT INTO option_item VALUES(114,29,2,'Manter o registro das contas de usuários do sistema e suas informações básicas.',1);
INSERT INTO option_item VALUES(115,29,3,'Guardar senhas criptografadas em texto plano.',0);
INSERT INTO option_item VALUES(116,29,4,'Configurar o endereço IP da placa de rede.',0);
INSERT INTO option_item VALUES(117,30,1,'Princípios, garantias, direitos e deveres para o uso da internet no Brasil, destacando a neutralidade da rede.',1);
INSERT INTO option_item VALUES(118,30,2,'A proibição de vendas de computadores sem sistema operacional livre.',0);
INSERT INTO option_item VALUES(119,30,3,'A regulamentação exclusiva de jogos eletrônicos.',0);
INSERT INTO option_item VALUES(120,30,4,'A obrigatoriedade de senhas com 32 caracteres.',0);
INSERT INTO option_item VALUES(121,31,1,'INSERT INTO',0);
INSERT INTO option_item VALUES(122,31,2,'CREATE TABLE',1);
INSERT INTO option_item VALUES(123,31,3,'SELECT * FROM',0);
INSERT INTO option_item VALUES(124,31,4,'UPDATE',0);
INSERT INTO option_item VALUES(125,32,1,'GROUP BY',0);
INSERT INTO option_item VALUES(126,32,2,'WHERE',1);
INSERT INTO option_item VALUES(127,32,3,'ORDER BY',0);
INSERT INTO option_item VALUES(128,32,4,'UNION',0);
INSERT INTO option_item VALUES(129,33,1,'Retorna todos os registros da tabela à esquerda, mesmo sem correspondência.',0);
INSERT INTO option_item VALUES(130,33,2,'Retorna apenas os registros que possuem correspondência (correspondências exatas) em ambas as tabelas.',1);
INSERT INTO option_item VALUES(131,33,3,'Retorna o produto cartesiano absoluto sem restrições.',0);
INSERT INTO option_item VALUES(132,33,4,'Apaga dados duplicados.',0);
INSERT INTO option_item VALUES(133,34,1,'Aumentar a redundância de dados para melhorar a velocidade de gravação em disco.',0);
INSERT INTO option_item VALUES(134,34,2,'Organizar as tabelas e colunas para reduzir a redundância de dados e evitar anomalias de atualização, inserção e exclusão.',1);
INSERT INTO option_item VALUES(135,34,3,'Criptografar senhas de usuários com algoritmos de mão única.',0);
INSERT INTO option_item VALUES(136,34,4,'Converter banco relacional em não relacional.',0);
INSERT INTO option_item VALUES(137,35,1,'Um arquivo de texto backup compactado.',0);
INSERT INTO option_item VALUES(138,35,2,'Um bloco de código SQL compilado e armazenado no servidor de banco de dados, executado sob demanda.',1);
INSERT INTO option_item VALUES(139,35,3,'Uma restrição de chave estrangeira.',0);
INSERT INTO option_item VALUES(140,35,4,'Um tipo de dado geométrico.',0);
INSERT INTO option_item VALUES(141,36,1,'DROP TABLE',0);
INSERT INTO option_item VALUES(142,36,2,'DELETE FROM',1);
INSERT INTO option_item VALUES(143,36,3,'REMOVE',0);
INSERT INTO option_item VALUES(144,36,4,'ALTER TABLE',0);
INSERT INTO option_item VALUES(145,37,1,'A interface gráfica de usuário mobile em Flutter.',0);
INSERT INTO option_item VALUES(146,37,2,'A representação conceitual e lógica da estrutura de dados, entidades, atributos e seus relacionamentos.',1);
INSERT INTO option_item VALUES(147,37,3,'O código fonte da aplicação Back-End em Node.js.',0);
INSERT INTO option_item VALUES(148,37,4,'O plano de testes automatizados com Selenium.',0);
INSERT INTO option_item VALUES(149,38,1,'Somar os valores numéricos de uma coluna inteira.',0);
INSERT INTO option_item VALUES(150,38,2,'Contar o número de linhas ou registros que atendem a um determinado critério.',1);
INSERT INTO option_item VALUES(151,38,3,'Encontrar o valor máximo em uma coluna.',0);
INSERT INTO option_item VALUES(152,38,4,'Calcular a média aritmética dos dados.',0);
INSERT INTO option_item VALUES(153,39,1,'<header>',1);
INSERT INTO option_item VALUES(154,39,2,'<foot>',0);
INSERT INTO option_item VALUES(155,39,3,'<div id=''topo''>',0);
INSERT INTO option_item VALUES(156,39,4,'<section-top>',0);
INSERT INTO option_item VALUES(157,40,1,'class',0);
INSERT INTO option_item VALUES(158,40,2,'type',1);
INSERT INTO option_item VALUES(159,40,3,'href',0);
INSERT INTO option_item VALUES(160,40,4,'src',0);
INSERT INTO option_item VALUES(161,41,1,'HyperText Markup Language',1);
INSERT INTO option_item VALUES(162,41,2,'High Transfer Machine Language',0);
INSERT INTO option_item VALUES(163,41,3,'Hyperlink and Text Management Logic',0);
INSERT INTO option_item VALUES(164,41,4,'Home Tool Multi Language',0);
INSERT INTO option_item VALUES(165,42,1,'rgb(255, 0, 0)',1);
INSERT INTO option_item VALUES(166,42,2,'#ZZ1122',0);
INSERT INTO option_item VALUES(167,42,3,'color: red-bright-500;',0);
INSERT INTO option_item VALUES(168,42,4,'rgb-mix(red, 100%)',0);
INSERT INTO option_item VALUES(169,43,1,'<ol>',0);
INSERT INTO option_item VALUES(170,43,2,'<ul>',1);
INSERT INTO option_item VALUES(171,43,3,'<list>',0);
INSERT INTO option_item VALUES(172,43,4,'<dl>',0);
INSERT INTO option_item VALUES(173,44,1,'Conectar o banco de dados MySQL à página web.',0);
INSERT INTO option_item VALUES(174,44,2,'Definar a codificação de caracteres do documento para suportar acentuação e caracteres especiais da língua portuguesa.',1);
INSERT INTO option_item VALUES(175,44,3,'Importar estilos CSS externos.',0);
INSERT INTO option_item VALUES(176,44,4,'Definir a velocidade de carregamento da imagem de fundo.',0);
INSERT INTO option_item VALUES(177,45,1,'document.getElementById(''meuId'')',1);
INSERT INTO option_item VALUES(178,45,2,'document.getElementsByClassName(''meuId'')',0);
INSERT INTO option_item VALUES(179,45,3,'document.queryAllTags(''id'')',0);
INSERT INTO option_item VALUES(180,45,4,'window.findId(''meuId'')',0);
INSERT INTO option_item VALUES(181,46,1,'Um banco de dados NoSQL embarcado no navegador.',0);
INSERT INTO option_item VALUES(182,46,2,'Uma interface de programação que representa a estrutura da página web como uma árvore de objetos, permitindo modificá-la via JavaScript.',1);
INSERT INTO option_item VALUES(183,46,3,'Um compilador de código C++ para WebAssembly.',0);
INSERT INTO option_item VALUES(184,46,4,'Um framework CSS concorrente do Bootstrap.',0);
INSERT INTO option_item VALUES(185,47,1,'.cabecalho',0);
INSERT INTO option_item VALUES(186,47,2,'#cabecalho',1);
INSERT INTO option_item VALUES(187,47,3,'*cabecalho',0);
INSERT INTO option_item VALUES(188,47,4,'element(cabecalho)',0);
INSERT INTO option_item VALUES(189,48,1,'var',0);
INSERT INTO option_item VALUES(190,48,2,'let',1);
INSERT INTO option_item VALUES(191,48,3,'const',0);
INSERT INTO option_item VALUES(192,48,4,'static',0);
INSERT INTO option_item VALUES(193,49,1,'align-items',0);
INSERT INTO option_item VALUES(194,49,2,'justify-content',1);
INSERT INTO option_item VALUES(195,49,3,'flex-wrap',0);
INSERT INTO option_item VALUES(196,49,4,'grid-template',0);
INSERT INTO option_item VALUES(197,50,1,'botao.addEventListener(''click'', funcaoCallback);',1);
INSERT INTO option_item VALUES(198,50,2,'botao.onClick(''click'', funcao);',0);
INSERT INTO option_item VALUES(199,50,3,'botao.bindEvent(''click'');',0);
INSERT INTO option_item VALUES(200,50,4,'document.click(botao);',0);
INSERT INTO option_item VALUES(201,51,1,'Um banco de dados relacional em nuvem.',0);
INSERT INTO option_item VALUES(202,51,2,'Funções que possuem acesso ao objeto de requisição (req), de resposta (res) e à próxima função de middleware no ciclo da aplicação.',1);
INSERT INTO option_item VALUES(203,51,3,'Uma biblioteca de estilização CSS.',0);
INSERT INTO option_item VALUES(204,51,4,'Um protocolo de rede para IoT.',0);
INSERT INTO option_item VALUES(205,52,1,'O uso obrigatório de arquivos binários criptografados para comunicação.',0);
INSERT INTO option_item VALUES(206,52,2,'O uso dos métodos HTTP padrão (GET, POST, PUT, DELETE) de forma stateless (sem estado) sobre recursos URI.',1);
INSERT INTO option_item VALUES(207,52,3,'A necessidade de manter conexões persistentes via WebSockets contínuos.',0);
INSERT INTO option_item VALUES(208,52,4,'O processamento exclusivo no navegador do cliente.',0);
INSERT INTO option_item VALUES(209,53,1,'Gerenciar pacotes, bibliotecas e dependências de projetos Node.js.',1);
INSERT INTO option_item VALUES(210,53,2,'Compilar código C++ para microcontroladores Arduino.',0);
INSERT INTO option_item VALUES(211,53,3,'Executar testes de interface gráfica em navegadores.',0);
INSERT INTO option_item VALUES(212,53,4,'Criar diagramas UML de classes.',0);
INSERT INTO option_item VALUES(213,54,1,'Ele trava a execução de todas as requisições até que a primeira termine.',0);
INSERT INTO option_item VALUES(214,54,2,'Ele utiliza uma única thread principal com um loop de eventos (event loop) para processar operações de I/O de forma não bloqueante.',1);
INSERT INTO option_item VALUES(215,54,3,'Ele executa código exclusivamente em múltiplos núcleos de hardware sem gerenciamento de software.',0);
INSERT INTO option_item VALUES(216,54,4,'Ele é incompatível com protocolos web modernos.',0);
INSERT INTO option_item VALUES(217,55,1,'A necessidade de reescrever todo o código nativo em linguagem Assembly para cada sistema.',0);
INSERT INTO option_item VALUES(218,55,2,'A capacidade de desenvolver aplicativos para múltiplas plataformas (Android e iOS) a partir de uma única base de código.',1);
INSERT INTO option_item VALUES(219,55,3,'A proibição de uso de banco de dados locais.',0);
INSERT INTO option_item VALUES(220,55,4,'O funcionamento exclusivo em servidores em nuvem sem instalação no aparelho.',0);
INSERT INTO option_item VALUES(221,56,1,'onDestroy()',0);
INSERT INTO option_item VALUES(222,56,2,'onResume() ou equivalente de exibição',1);
INSERT INTO option_item VALUES(223,56,3,'onCompile()',0);
INSERT INTO option_item VALUES(224,56,4,'onShutdown()',0);
INSERT INTO option_item VALUES(225,57,1,'Testes realizados pelo cliente final após a implantação em produção.',0);
INSERT INTO option_item VALUES(226,57,2,'Testes automatizados que verificam a menor unidade de código isolada (como uma função ou método) para garantir que ela funcione corretamente.',1);
INSERT INTO option_item VALUES(227,57,3,'Testes de carga realizados por 10.000 usuários simultâneos.',0);
INSERT INTO option_item VALUES(228,57,4,'Inspeção visual do leiaute CSS em monitores 4K.',0);
INSERT INTO option_item VALUES(229,58,1,'Testes de caixa preta testam a funcionalidade com base nos requisitos sem conhecer o código interno, enquanto caixa branca examinam a estrutura interna e o código fonte.',1);
INSERT INTO option_item VALUES(230,58,2,'Testes de caixa preta são feitos apenas em hardware IoT e caixa branca em HTML.',0);
INSERT INTO option_item VALUES(231,58,3,'Testes de caixa branca não exigem automação.',0);
INSERT INTO option_item VALUES(232,58,4,'Caixa preta é executada apenas por analistas de infraestrutura.',0);
INSERT INTO option_item VALUES(233,59,1,'Servir exclusivamente como monitor de vídeo corporativo.',0);
INSERT INTO option_item VALUES(234,59,2,'Ler sinais de sensores físicos, processar lógica local e atuar em dispositivos conectados à rede.',1);
INSERT INTO option_item VALUES(235,59,3,'Atuar como servidor de banco de dados relacional corporativo pesado.',0);
INSERT INTO option_item VALUES(236,59,4,'Substituir sistemas operacionais de computadores de mesa.',0);
INSERT INTO option_item VALUES(237,60,1,'Para garantir a usabilidade, a manutenção futura do sistema e a correta operação por parte dos usuários.',1);
INSERT INTO option_item VALUES(238,60,2,'Para aumentar intencionalmente os custos do projeto.',0);
INSERT INTO option_item VALUES(239,60,3,'Para impedir que o cliente utilize o código fonte.',0);
INSERT INTO option_item VALUES(240,60,4,'Para eliminar a necessidade de testes de software.',0);
CREATE TABLE question_subject (
    question_id INTEGER NOT NULL REFERENCES question(id) ON DELETE CASCADE,
    subject_id INTEGER NOT NULL REFERENCES subject(id) ON DELETE RESTRICT,
    PRIMARY KEY (question_id, subject_id)
);
INSERT INTO question_subject VALUES(1,6);
INSERT INTO question_subject VALUES(2,6);
INSERT INTO question_subject VALUES(3,6);
INSERT INTO question_subject VALUES(4,6);
INSERT INTO question_subject VALUES(5,6);
INSERT INTO question_subject VALUES(6,6);
INSERT INTO question_subject VALUES(7,6);
INSERT INTO question_subject VALUES(8,6);
INSERT INTO question_subject VALUES(9,7);
INSERT INTO question_subject VALUES(10,7);
INSERT INTO question_subject VALUES(11,7);
INSERT INTO question_subject VALUES(12,7);
INSERT INTO question_subject VALUES(13,7);
INSERT INTO question_subject VALUES(14,7);
INSERT INTO question_subject VALUES(15,7);
INSERT INTO question_subject VALUES(16,8);
INSERT INTO question_subject VALUES(17,8);
INSERT INTO question_subject VALUES(18,8);
INSERT INTO question_subject VALUES(19,8);
INSERT INTO question_subject VALUES(20,8);
INSERT INTO question_subject VALUES(21,8);
INSERT INTO question_subject VALUES(22,8);
INSERT INTO question_subject VALUES(23,9);
INSERT INTO question_subject VALUES(24,9);
INSERT INTO question_subject VALUES(25,9);
INSERT INTO question_subject VALUES(26,9);
INSERT INTO question_subject VALUES(27,9);
INSERT INTO question_subject VALUES(28,9);
INSERT INTO question_subject VALUES(29,9);
INSERT INTO question_subject VALUES(30,9);
INSERT INTO question_subject VALUES(31,2);
INSERT INTO question_subject VALUES(32,2);
INSERT INTO question_subject VALUES(33,2);
INSERT INTO question_subject VALUES(34,2);
INSERT INTO question_subject VALUES(35,2);
INSERT INTO question_subject VALUES(36,2);
INSERT INTO question_subject VALUES(37,2);
INSERT INTO question_subject VALUES(38,2);
INSERT INTO question_subject VALUES(39,10);
INSERT INTO question_subject VALUES(40,10);
INSERT INTO question_subject VALUES(41,10);
INSERT INTO question_subject VALUES(42,10);
INSERT INTO question_subject VALUES(43,10);
INSERT INTO question_subject VALUES(44,10);
INSERT INTO question_subject VALUES(45,11);
INSERT INTO question_subject VALUES(46,11);
INSERT INTO question_subject VALUES(47,11);
INSERT INTO question_subject VALUES(48,11);
INSERT INTO question_subject VALUES(49,11);
INSERT INTO question_subject VALUES(50,11);
INSERT INTO question_subject VALUES(51,12);
INSERT INTO question_subject VALUES(52,12);
INSERT INTO question_subject VALUES(53,12);
INSERT INTO question_subject VALUES(54,12);
INSERT INTO question_subject VALUES(55,13);
INSERT INTO question_subject VALUES(56,13);
INSERT INTO question_subject VALUES(57,14);
INSERT INTO question_subject VALUES(58,14);
INSERT INTO question_subject VALUES(59,15);
INSERT INTO question_subject VALUES(60,16);
CREATE TABLE simulation (
    id INTEGER PRIMARY KEY,
    author_id INTEGER NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
    title TEXT NOT NULL,
    duration_minutes INTEGER CHECK (duration_minutes IS NULL OR duration_minutes > 0),
    question_count INTEGER NOT NULL CHECK (question_count > 0),
    status TEXT NOT NULL DEFAULT 'draft'
        CHECK (status IN ('draft', 'published', 'archived')),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO simulation VALUES(1,2,'Simulado SAEP 2026 - Banco de Questões',120,60,'published','2026-09-14 15:52:20');
CREATE TABLE simulation_question (
    simulation_id INTEGER NOT NULL REFERENCES simulation(id) ON DELETE CASCADE,
    question_id INTEGER NOT NULL REFERENCES question(id) ON DELETE RESTRICT,
    position INTEGER NOT NULL CHECK (position > 0),
    points REAL NOT NULL DEFAULT 1 CHECK (points > 0),
    statement_snapshot TEXT NOT NULL,
    options_snapshot TEXT NOT NULL CHECK (json_valid(options_snapshot)),
    PRIMARY KEY (simulation_id, question_id),
    UNIQUE (simulation_id, position)
);
INSERT INTO simulation_question VALUES(1,1,1,1.0,'Em um algoritmo, qual estrutura de controle é mais adequada para executar um conjunto de instruções um número determinado de vezes, utilizando uma variável de contagem?','[{"position":1,"content":"Estrutura condicional simples (if)","is_correct":0},{"position":2,"content":"Laço de repetição com contador (for)","is_correct":1},{"position":3,"content":"Estrutura de seleção múltipla (switch)","is_correct":0},{"position":4,"content":"Laço condicional pré-testado (while)","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,2,2,1.0,'Qual operador lógico retorna verdadeiro (true) se e somente se AMBAS as condições avaliadas forem verdadeiras?','[{"position":1,"content":"E (AND)","is_correct":1},{"position":2,"content":"OU (OR)","is_correct":0},{"position":3,"content":"NÃO (NOT)","is_correct":0},{"position":4,"content":"OU Exclusivo (XOR)","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,3,3,1.0,'O que caracteriza a adoção de técnicas de código limpo (Clean Code) no desenvolvimento de software?','[{"position":1,"content":"Abreviar ao máximo os nomes de variáveis para economizar memória do computador.","is_correct":0},{"position":2,"content":"Escrever códigos legíveis, fáceis de manter, com nomes significativos e funções coesas.","is_correct":1},{"position":3,"content":"Eliminar completamente a necessidade de comentários e documentação em qualquer projeto.","is_correct":0},{"position":4,"content":"Utilizar exclusivamente paradigmas de programação de baixo nível.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,4,4,1.0,'No contexto do Git (sistema de controle de versão distribuído), qual comando é utilizado para registrar as alterações efetivadas no repositório local?','[{"position":1,"content":"git clone","is_correct":0},{"position":2,"content":"git push","is_correct":0},{"position":3,"content":"git commit","is_correct":1},{"position":4,"content":"git init","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,5,5,1.0,'Em linguagens de programação, qual é a principal diferença entre variáveis e constantes?','[{"position":1,"content":"Variáveis armazenam apenas números inteiros, enquanto constantes armazenam textos.","is_correct":0},{"position":2,"content":"O valor de uma variável pode ser alterado durante a execução do programa, enquanto o valor de uma constante permanece fixo.","is_correct":1},{"position":3,"content":"Constantes ocupam espaço em disco, ao passo que variáveis residem apenas na CPU.","is_correct":0},{"position":4,"content":"Variáveis não exigem declaração de tipo prévia em nenhuma linguagem.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,6,6,1.0,'O que representa uma matriz em programação estruturada?','[{"position":1,"content":"Uma variável simples de armazenamento de caractere único.","is_correct":0},{"position":2,"content":"Uma estrutura de dados homogênea bidimensional (linhas e colunas).","is_correct":1},{"position":3,"content":"Um comando de repetição condicional aninhado.","is_correct":0},{"position":4,"content":"Uma função matemática de criptografia.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,7,7,1.0,'Qual plataforma de versionamento em nuvem utiliza o conceito de ''Pull Requests'' para propor e revisar alterações de código em equipes?','[{"position":1,"content":"GitHub","is_correct":1},{"position":2,"content":"Apache HTTP Server","is_correct":0},{"position":3,"content":"MySQL Workbench","is_correct":0},{"position":4,"content":"Visual Studio Code","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,8,8,1.0,'Qual é a finalidade principal de um fluxograma na elaboração de algoritmos?','[{"position":1,"content":"Compilar código fonte diretamente para linguagem de máquina.","is_correct":0},{"position":2,"content":"Representar graficamente a sequência lógica de passos e fluxos de decisão de um processo.","is_correct":1},{"position":3,"content":"Configurar endereços IP em redes locais.","is_correct":0},{"position":4,"content":"Gerenciar tabelas relacionais em SGBDs.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,9,9,1.0,'Qual é a principal distinção entre requisitos funcionais e não funcionais em um sistema?','[{"position":1,"content":"Requisitos funcionais tratam de custos financeiros, enquanto os não funcionais tratam de prazos.","is_correct":0},{"position":2,"content":"Requisitos funcionais descrevem o que o sistema faz (ações e serviços), e os não funcionais descrevem restrições de qualidade, desempenho e segurança.","is_correct":1},{"position":3,"content":"Requisitos funcionais são criados pelo cliente e os não funcionais pelo programador júnior.","is_correct":0},{"position":4,"content":"Requisitos não funcionais são opcionais em qualquer projeto ágil.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,10,10,1.0,'Na metodologia ágil Scrum, qual papel é o principal responsável por gerenciar o Product Backlog e priorizar os itens de acordo com o valor de negócio?','[{"position":1,"content":"Scrum Master","is_correct":0},{"position":2,"content":"Product Owner (P.O.)","is_correct":1},{"position":3,"content":"Lead Developer","is_correct":0},{"position":4,"content":"Quality Assurance (QA)","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,11,11,1.0,'Quais são as etapas fundamentais que compõem o processo do Design Thinking?','[{"position":1,"content":"Empatia, Ideação, Prototipação, Teste e Implementação.","is_correct":1},{"position":2,"content":"Compilação, Teste Unitário, Deploy e Manutenção.","is_correct":0},{"position":3,"content":"MER, DER, Normalização e DDL.","is_correct":0},{"position":4,"content":"Briefing, Commit, Push e Merge.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,12,12,1.0,'O que é um quadro Kanban e qual sua utilidade na gestão de projetos?','[{"position":1,"content":"Um software antivírus para proteção de servidores web.","is_correct":0},{"position":2,"content":"Uma ferramenta visual de gerenciamento de fluxo de trabalho que categoriza tarefas em colunas como A Fazer, Em Andamento e Concluído.","is_correct":1},{"position":3,"content":"Um diagrama de classes em UML.","is_correct":0},{"position":4,"content":"Uma linguagem de marcação estruturada.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,13,13,1.0,'Qual técnica de levantamento de requisitos envolve a observação direta dos usuários executando suas tarefas no ambiente real de trabalho?','[{"position":1,"content":"Etnografia","is_correct":1},{"position":2,"content":"Brainstorming","is_correct":0},{"position":3,"content":"Diagrama de Entidade-Relacionamento","is_correct":0},{"position":4,"content":"Teste de estresse","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,14,14,1.0,'O que define uma Regra de Negócio durante a elicitação de requisitos?','[{"position":1,"content":"A velocidade da conexão de rede exigida pelo servidor.","is_correct":0},{"position":2,"content":"Diretrizes, políticas e restrições operacionais que a organização deve seguir em seus processos.","is_correct":1},{"position":3,"content":"O número máximo de linhas de código permitidas por arquivo.","is_correct":0},{"position":4,"content":"A versão do SGBD utilizada na produção.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,15,15,1.0,'Qual é o objetivo do documento de Briefing no início de um projeto de software?','[{"position":1,"content":"Descrever detalhadamente o código binário compilado.","is_correct":0},{"position":2,"content":"Coletar as necessidades iniciais, expectativas e objetivos do cliente para nortear o projeto.","is_correct":1},{"position":3,"content":"Realizar o teste de aceitação final do sistema.","is_correct":0},{"position":4,"content":"Configurar o roteador Wi-Fi da empresa.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,16,16,1.0,'Qual protocolo leve de mensagens baseado em publicação/assinatura (Pub/Sub) é amplamente utilizado em dispositivos IoT e automação industrial?','[{"position":1,"content":"HTTP","is_correct":0},{"position":2,"content":"MQTT (Message Queuing Telemetry Transport)","is_correct":1},{"position":3,"content":"FTP","is_correct":0},{"position":4,"content":"RDP","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,17,17,1.0,'O que caracteriza uma topologia de rede em Malha (Mesh)?','[{"position":1,"content":"Todos os nós são conectados a um único cabo central (Barramento).","is_correct":0},{"position":2,"content":"Dispositivos possuem múltiplos caminhos de interconexão entre si, oferecendo alta redundância e tolerância a falhas.","is_correct":1},{"position":3,"content":"Os computadores formam um círculo fechado onde os dados circulam em um sentido.","is_correct":0},{"position":4,"content":"Um nó central (como um switch) conecta todos os demais nós.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,18,18,1.0,'No endereçamento IPv4, quantos bits compõem o endereço IP completo?','[{"position":1,"content":"32 bits","is_correct":1},{"position":2,"content":"64 bits","is_correct":0},{"position":3,"content":"128 bits","is_correct":0},{"position":4,"content":"16 bits","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,19,19,1.0,'Qual dispositivo de rede atua na camada de rede (Camada 3 do OSI) encaminhando pacotes entre redes distintas?','[{"position":1,"content":"Switch de camada 2","is_correct":0},{"position":2,"content":"Roteador","is_correct":1},{"position":3,"content":"Hub passivo","is_correct":0},{"position":4,"content":"Cabo coaxial","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,20,20,1.0,'O que significam os componentes de I/O (Inputs e Outputs) na arquitetura de hardware voltada para IoT?','[{"position":1,"content":"Interfaces de entrada (sensores, botões) e saída (atuadores, LEDs, motores) para interação com o mundo físico.","is_correct":1},{"position":2,"content":"Sistemas operacionais de código fechado para servidores em nuvem.","is_correct":0},{"position":3,"content":"Protocolos de criptografia de banco de dados.","is_correct":0},{"position":4,"content":"Ferramentas de controle de versão Git.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,21,21,1.0,'Qual porta padrão é utilizada pelo protocolo HTTPS para requisições web seguras?','[{"position":1,"content":"Porta 80","is_correct":0},{"position":2,"content":"Porta 443","is_correct":1},{"position":3,"content":"Porta 21","is_correct":0},{"position":4,"content":"Porta 3306","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,22,22,1.0,'Em arquiteturas de rede, o que caracteriza o modelo Cliente-Servidor?','[{"position":1,"content":"Todos os computadores possuem exatamente o mesmo nível hierárquico sem servidor central.","is_correct":0},{"position":2,"content":"Um ou mais computadores centrais (servidores) fornecem recursos e serviços para os demais computadores (clientes) da rede.","is_correct":1},{"position":3,"content":"A comunicação ocorre exclusivamente via rádio frequência sem fio.","is_correct":0},{"position":4,"content":"Os dados ficam armazenados de forma descentralizada via blockchain.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,23,23,1.0,'No sistema operacional Linux (código aberto), qual comando em modo texto é utilizado para navegar entre diretórios?','[{"position":1,"content":"ls","is_correct":0},{"position":2,"content":"cd","is_correct":1},{"position":3,"content":"mkdir","is_correct":0},{"position":4,"content":"rm","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,24,24,1.0,'Qual é a principal função de um Firewall nativo em um sistema operacional?','[{"position":1,"content":"Acelerar a velocidade de download de arquivos grandes.","is_correct":0},{"position":2,"content":"Controlar e filtrar o tráfego de rede de entrada e saída com base em regras de segurança pré-estabelecidas.","is_correct":1},{"position":3,"content":"Compactar arquivos para economizar espaço em disco.","is_correct":0},{"position":4,"content":"Gerenciar permissões de usuários em banco de dados.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,25,25,1.0,'O que estabelece a Lei Geral de Proteção de Dados (LGPD - Lei nº 13.709/2018) no Brasil?','[{"position":1,"content":"Regras rígidas sobre coleta, armazenamento e tratamento de dados pessoais de indivíduos por organizações públicas e privadas.","is_correct":1},{"position":2,"content":"A obrigatoriedade de uso do sistema Linux em órgãos governamentais.","is_correct":0},{"position":3,"content":"O marco regulatório para infraestrutura de fibra óptica em zonas rurais.","is_correct":0},{"position":4,"content":"A taxação de impostos sobre e-commerces internacionais.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,26,26,1.0,'O que é uma VPN (Virtual Private Network) utilizada em sistemas operacionais e redes?','[{"position":1,"content":"Um tipo de vírus que rouba senhas de administradores.","is_correct":0},{"position":2,"content":"Um túnel criptografado que permite conectar dispositivos com segurança a uma rede privada através de uma rede pública (como a internet).","is_correct":1},{"position":3,"content":"Um protocolo de compactação de vídeos em alta definição.","is_correct":0},{"position":4,"content":"Uma interface gráfica para gerenciamento de memória RAM.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,27,27,1.0,'Qual comando Linux é utilizado para criar um novo diretório (pasta)?','[{"position":1,"content":"touch","is_correct":0},{"position":2,"content":"mkdir","is_correct":1},{"position":3,"content":"cat","is_correct":0},{"position":4,"content":"pwd","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,28,28,1.0,'O que caracteriza um ataque de Engenharia Social no contexto da segurança cibernética?','[{"position":1,"content":"A exploração de falhas em placas de vídeo de alta performance.","is_correct":0},{"position":2,"content":"A manipulação psicológica de usuários para induzi-los a revelar informações confidenciais ou senhas.","is_correct":1},{"position":3,"content":"Um curto-circuito em servidores de data center.","is_correct":0},{"position":4,"content":"A sobrecarga de requisições em um servidor web (DDoS).","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,29,29,1.0,'Qual é a finalidade do arquivo /etc/passwd ou gerenciamento de usuários em sistemas operacionais Unix/Linux?','[{"position":1,"content":"Armazenar logs de conexões Wi-Fi.","is_correct":0},{"position":2,"content":"Manter o registro das contas de usuários do sistema e suas informações básicas.","is_correct":1},{"position":3,"content":"Guardar senhas criptografadas em texto plano.","is_correct":0},{"position":4,"content":"Configurar o endereço IP da placa de rede.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,30,30,1.0,'O que aborda o Marco Civil da Internet (Lei nº 12.965/2014) no Brasil?','[{"position":1,"content":"Princípios, garantias, direitos e deveres para o uso da internet no Brasil, destacando a neutralidade da rede.","is_correct":1},{"position":2,"content":"A proibição de vendas de computadores sem sistema operacional livre.","is_correct":0},{"position":3,"content":"A regulamentação exclusiva de jogos eletrônicos.","is_correct":0},{"position":4,"content":"A obrigatoriedade de senhas com 32 caracteres.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,31,31,1.0,'Qual comando SQL pertence à DDL (Data Definition Language) e é utilizado para criar uma nova tabela no banco de dados?','[{"position":1,"content":"INSERT INTO","is_correct":0},{"position":2,"content":"CREATE TABLE","is_correct":1},{"position":3,"content":"SELECT * FROM","is_correct":0},{"position":4,"content":"UPDATE","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,32,32,1.0,'Qual cláusula SQL é utilizada para filtrar registros retornados por uma consulta com base em condições específicas?','[{"position":1,"content":"GROUP BY","is_correct":0},{"position":2,"content":"WHERE","is_correct":1},{"position":3,"content":"ORDER BY","is_correct":0},{"position":4,"content":"UNION","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,33,33,1.0,'O que realiza uma operação de INNER JOIN entre duas tabelas?','[{"position":1,"content":"Retorna todos os registros da tabela à esquerda, mesmo sem correspondência.","is_correct":0},{"position":2,"content":"Retorna apenas os registros que possuem correspondência (correspondências exatas) em ambas as tabelas.","is_correct":1},{"position":3,"content":"Retorna o produto cartesiano absoluto sem restrições.","is_correct":0},{"position":4,"content":"Apaga dados duplicados.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,34,34,1.0,'Qual é o principal objetivo da Normalização de Banco de Dados?','[{"position":1,"content":"Aumentar a redundância de dados para melhorar a velocidade de gravação em disco.","is_correct":0},{"position":2,"content":"Organizar as tabelas e colunas para reduzir a redundância de dados e evitar anomalias de atualização, inserção e exclusão.","is_correct":1},{"position":3,"content":"Criptografar senhas de usuários com algoritmos de mão única.","is_correct":0},{"position":4,"content":"Converter banco relacional em não relacional.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,35,35,1.0,'O que é uma Stored Procedure (Procedimento Armazenado) em um SGBD?','[{"position":1,"content":"Um arquivo de texto backup compactado.","is_correct":0},{"position":2,"content":"Um bloco de código SQL compilado e armazenado no servidor de banco de dados, executado sob demanda.","is_correct":1},{"position":3,"content":"Uma restrição de chave estrangeira.","is_correct":0},{"position":4,"content":"Um tipo de dado geométrico.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,36,36,1.0,'Qual comando SQL é utilizado para remover registros existentes de uma tabela?','[{"position":1,"content":"DROP TABLE","is_correct":0},{"position":2,"content":"DELETE FROM","is_correct":1},{"position":3,"content":"REMOVE","is_correct":0},{"position":4,"content":"ALTER TABLE","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,37,37,1.0,'O que representa o Modelo Entidade-Relacionamento (MER) e seu respectivo Diagrama (DER)?','[{"position":1,"content":"A interface gráfica de usuário mobile em Flutter.","is_correct":0},{"position":2,"content":"A representação conceitual e lógica da estrutura de dados, entidades, atributos e seus relacionamentos.","is_correct":1},{"position":3,"content":"O código fonte da aplicação Back-End em Node.js.","is_correct":0},{"position":4,"content":"O plano de testes automatizados com Selenium.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,38,38,1.0,'Para que serve a função de agregação COUNT() em consultas SQL?','[{"position":1,"content":"Somar os valores numéricos de uma coluna inteira.","is_correct":0},{"position":2,"content":"Contar o número de linhas ou registros que atendem a um determinado critério.","is_correct":1},{"position":3,"content":"Encontrar o valor máximo em uma coluna.","is_correct":0},{"position":4,"content":"Calcular a média aritmética dos dados.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,39,39,1.0,'Qual tag HTML5 é semanticamente mais adequada para representar o cabeçalho principal de uma página ou seção?','[{"position":1,"content":"<header>","is_correct":1},{"position":2,"content":"<foot>","is_correct":0},{"position":3,"content":"<div id=''topo''>","is_correct":0},{"position":4,"content":"<section-top>","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,40,40,1.0,'Em formulários HTML, qual atributo do elemento `<input>` define o tipo de dado esperado (ex: texto, senha, e-mail, número)?','[{"position":1,"content":"class","is_correct":0},{"position":2,"content":"type","is_correct":1},{"position":3,"content":"href","is_correct":0},{"position":4,"content":"src","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,41,41,1.0,'O que significa a sigla HTML?','[{"position":1,"content":"HyperText Markup Language","is_correct":1},{"position":2,"content":"High Transfer Machine Language","is_correct":0},{"position":3,"content":"Hyperlink and Text Management Logic","is_correct":0},{"position":4,"content":"Home Tool Multi Language","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,42,42,1.0,'Como se representa uma cor utilizando o formato RGB em estilização ou atributos web?','[{"position":1,"content":"rgb(255, 0, 0)","is_correct":1},{"position":2,"content":"#ZZ1122","is_correct":0},{"position":3,"content":"color: red-bright-500;","is_correct":0},{"position":4,"content":"rgb-mix(red, 100%)","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,43,43,1.0,'Qual elemento HTML é utilizado para criar uma lista não ordenada (com marcadores em formato de pontos)?','[{"position":1,"content":"<ol>","is_correct":0},{"position":2,"content":"<ul>","is_correct":1},{"position":3,"content":"<list>","is_correct":0},{"position":4,"content":"<dl>","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,44,44,1.0,'Qual é a utilidade do elemento `<meta charset="UTF-8">` no cabeçalho de um documento HTML?','[{"position":1,"content":"Conectar o banco de dados MySQL à página web.","is_correct":0},{"position":2,"content":"Definar a codificação de caracteres do documento para suportar acentuação e caracteres especiais da língua portuguesa.","is_correct":1},{"position":3,"content":"Importar estilos CSS externos.","is_correct":0},{"position":4,"content":"Definir a velocidade de carregamento da imagem de fundo.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,45,45,1.0,'Em JavaScript, qual método ou forma é recomendada para selecionar um elemento HTML pelo seu atributo ID no DOM?','[{"position":1,"content":"document.getElementById(''meuId'')","is_correct":1},{"position":2,"content":"document.getElementsByClassName(''meuId'')","is_correct":0},{"position":3,"content":"document.queryAllTags(''id'')","is_correct":0},{"position":4,"content":"window.findId(''meuId'')","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,46,46,1.0,'O que é o DOM (Document Object Model) em aplicações web Front-End?','[{"position":1,"content":"Um banco de dados NoSQL embarcado no navegador.","is_correct":0},{"position":2,"content":"Uma interface de programação que representa a estrutura da página web como uma árvore de objetos, permitindo modificá-la via JavaScript.","is_correct":1},{"position":3,"content":"Um compilador de código C++ para WebAssembly.","is_correct":0},{"position":4,"content":"Um framework CSS concorrente do Bootstrap.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,47,47,1.0,'Qual seletor CSS é utilizado para aplicar estilos a um elemento específico que possui o atributo `id="cabecalho"`?','[{"position":1,"content":".cabecalho","is_correct":0},{"position":2,"content":"#cabecalho","is_correct":1},{"position":3,"content":"*cabecalho","is_correct":0},{"position":4,"content":"element(cabecalho)","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,48,48,1.0,'Em JavaScript moderno (ES6+), qual palavra-chave é utilizada para declarar uma variável escopada ao bloco cujo valor pode ser reatribuído?','[{"position":1,"content":"var","is_correct":0},{"position":2,"content":"let","is_correct":1},{"position":3,"content":"const","is_correct":0},{"position":4,"content":"static","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,49,49,1.0,'Qual propriedade do CSS Flexbox define o alinhamento dos itens ao longo do eixo principal (main axis)?','[{"position":1,"content":"align-items","is_correct":0},{"position":2,"content":"justify-content","is_correct":1},{"position":3,"content":"flex-wrap","is_correct":0},{"position":4,"content":"grid-template","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,50,50,1.0,'Como se adiciona um evento de clique a um botão utilizando JavaScript?','[{"position":1,"content":"botao.addEventListener(''click'', funcaoCallback);","is_correct":1},{"position":2,"content":"botao.onClick(''click'', funcao);","is_correct":0},{"position":3,"content":"botao.bindEvent(''click'');","is_correct":0},{"position":4,"content":"document.click(botao);","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,51,51,1.0,'No desenvolvimento Back-End com Node.js e Express, o que representa um ''Middleware''?','[{"position":1,"content":"Um banco de dados relacional em nuvem.","is_correct":0},{"position":2,"content":"Funções que possuem acesso ao objeto de requisição (req), de resposta (res) e à próxima função de middleware no ciclo da aplicação.","is_correct":1},{"position":3,"content":"Uma biblioteca de estilização CSS.","is_correct":0},{"position":4,"content":"Um protocolo de rede para IoT.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,52,52,1.0,'O que caracteriza uma API RESTful em arquiteturas Back-End?','[{"position":1,"content":"O uso obrigatório de arquivos binários criptografados para comunicação.","is_correct":0},{"position":2,"content":"O uso dos métodos HTTP padrão (GET, POST, PUT, DELETE) de forma stateless (sem estado) sobre recursos URI.","is_correct":1},{"position":3,"content":"A necessidade de manter conexões persistentes via WebSockets contínuos.","is_correct":0},{"position":4,"content":"O processamento exclusivo no navegador do cliente.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,53,53,1.0,'Qual é a função do npm (Node Package Manager) no ecossistema de desenvolvimento JavaScript?','[{"position":1,"content":"Gerenciar pacotes, bibliotecas e dependências de projetos Node.js.","is_correct":1},{"position":2,"content":"Compilar código C++ para microcontroladores Arduino.","is_correct":0},{"position":3,"content":"Executar testes de interface gráfica em navegadores.","is_correct":0},{"position":4,"content":"Criar diagramas UML de classes.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,54,54,1.0,'O que significa dizer que o Node.js possui arquitetura assíncrona e orientada a eventos com single-thread?','[{"position":1,"content":"Ele trava a execução de todas as requisições até que a primeira termine.","is_correct":0},{"position":2,"content":"Ele utiliza uma única thread principal com um loop de eventos (event loop) para processar operações de I/O de forma não bloqueante.","is_correct":1},{"position":3,"content":"Ele executa código exclusivamente em múltiplos núcleos de hardware sem gerenciamento de software.","is_correct":0},{"position":4,"content":"Ele é incompatível com protocolos web modernos.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,55,55,1.0,'O que caracteriza frameworks de desenvolvimento mobile multiplataforma (Cross-Platform) como Flutter ou React Native?','[{"position":1,"content":"A necessidade de reescrever todo o código nativo em linguagem Assembly para cada sistema.","is_correct":0},{"position":2,"content":"A capacidade de desenvolver aplicativos para múltiplas plataformas (Android e iOS) a partir de uma única base de código.","is_correct":1},{"position":3,"content":"A proibição de uso de banco de dados locais.","is_correct":0},{"position":4,"content":"O funcionamento exclusivo em servidores em nuvem sem instalação no aparelho.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,56,56,1.0,'No ciclo de vida de uma tela ou Activity em desenvolvimento mobile, qual método é executado quando a tela se torna visível para o usuário?','[{"position":1,"content":"onDestroy()","is_correct":0},{"position":2,"content":"onResume() ou equivalente de exibição","is_correct":1},{"position":3,"content":"onCompile()","is_correct":0},{"position":4,"content":"onShutdown()","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,57,57,1.0,'O que são Testes Unitários no processo de desenvolvimento de software?','[{"position":1,"content":"Testes realizados pelo cliente final após a implantação em produção.","is_correct":0},{"position":2,"content":"Testes automatizados que verificam a menor unidade de código isolada (como uma função ou método) para garantir que ela funcione corretamente.","is_correct":1},{"position":3,"content":"Testes de carga realizados por 10.000 usuários simultâneos.","is_correct":0},{"position":4,"content":"Inspeção visual do leiaute CSS em monitores 4K.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,58,58,1.0,'Qual é a principal diferença entre testes funcionais (caixa preta) e testes estruturais (caixa branca)?','[{"position":1,"content":"Testes de caixa preta testam a funcionalidade com base nos requisitos sem conhecer o código interno, enquanto caixa branca examinam a estrutura interna e o código fonte.","is_correct":1},{"position":2,"content":"Testes de caixa preta são feitos apenas em hardware IoT e caixa branca em HTML.","is_correct":0},{"position":3,"content":"Testes de caixa branca não exigem automação.","is_correct":0},{"position":4,"content":"Caixa preta é executada apenas por analistas de infraestrutura.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,59,59,1.0,'Qual é o papel de uma placa microcontrolada (como ESP32 ou Arduino) em um projeto de Internet das Coisas (IoT)?','[{"position":1,"content":"Servir exclusivamente como monitor de vídeo corporativo.","is_correct":0},{"position":2,"content":"Ler sinais de sensores físicos, processar lógica local e atuar em dispositivos conectados à rede.","is_correct":1},{"position":3,"content":"Atuar como servidor de banco de dados relacional corporativo pesado.","is_correct":0},{"position":4,"content":"Substituir sistemas operacionais de computadores de mesa.","is_correct":0}]');
INSERT INTO simulation_question VALUES(1,60,60,1.0,'No encerramento e entrega de um projeto de software integrando todas as UCs do curso técnico, por que a documentação técnica e o treinamento do usuário final são fundamentais?','[{"position":1,"content":"Para garantir a usabilidade, a manutenção futura do sistema e a correta operação por parte dos usuários.","is_correct":1},{"position":2,"content":"Para aumentar intencionalmente os custos do projeto.","is_correct":0},{"position":3,"content":"Para impedir que o cliente utilize o código fonte.","is_correct":0},{"position":4,"content":"Para eliminar a necessidade de testes de software.","is_correct":0}]');
CREATE TABLE attempt (
    id INTEGER PRIMARY KEY,
    simulation_id INTEGER NOT NULL REFERENCES simulation(id) ON DELETE RESTRICT,
    user_id INTEGER NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
    started_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    finished_at TEXT,
    score REAL CHECK (score IS NULL OR score >= 0),
    status TEXT NOT NULL DEFAULT 'in_progress'
        CHECK (status IN ('in_progress', 'finished', 'cancelled')),
    CHECK (finished_at IS NULL OR status <> 'in_progress')
);
CREATE TABLE attempt_answer (
    id INTEGER PRIMARY KEY,
    attempt_id INTEGER NOT NULL REFERENCES attempt(id) ON DELETE CASCADE,
    question_id INTEGER NOT NULL REFERENCES question(id) ON DELETE RESTRICT,
    selected_option_id INTEGER REFERENCES option_item(id) ON DELETE RESTRICT,
    option_order TEXT NOT NULL CHECK (json_valid(option_order)),
    is_correct INTEGER CHECK (is_correct IS NULL OR is_correct IN (0, 1)),
    elapsed_seconds INTEGER CHECK (elapsed_seconds IS NULL OR elapsed_seconds >= 0),
    UNIQUE (attempt_id, question_id)
);
CREATE TRIGGER question_updated_at
AFTER UPDATE OF statement, explanation, hint, difficulty, status ON question
FOR EACH ROW
BEGIN
    UPDATE question SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE TRIGGER question_publish_validation
BEFORE UPDATE OF status ON question
FOR EACH ROW
WHEN NEW.status = 'published'
BEGIN
    SELECT CASE
        WHEN (SELECT COUNT(*) FROM option_item WHERE question_id = NEW.id) NOT IN (4, 5)
        THEN RAISE(ABORT, 'published question must have 4 or 5 options')
    END;
    SELECT CASE
        WHEN (SELECT COUNT(*) FROM option_item WHERE question_id = NEW.id AND is_correct = 1) <> 1
        THEN RAISE(ABORT, 'published question must have exactly one correct option')
    END;
    SELECT CASE
        WHEN (SELECT COUNT(*) FROM question_subject WHERE question_id = NEW.id) = 0
        THEN RAISE(ABORT, 'published question must have at least one subject')
    END;
END;
CREATE TRIGGER simulation_question_published_only
BEFORE INSERT ON simulation_question
FOR EACH ROW
WHEN (SELECT status FROM question WHERE id = NEW.question_id) <> 'published'
BEGIN
    SELECT RAISE(ABORT, 'only published questions can enter a simulation');
END;
CREATE INDEX idx_question_filter
    ON question(status, difficulty, source_id);
CREATE INDEX idx_question_subject_subject
    ON question_subject(subject_id, question_id);
CREATE INDEX idx_option_question
    ON option_item(question_id, position);
CREATE INDEX idx_simulation_status
    ON simulation(status, created_at);
CREATE INDEX idx_attempt_user
    ON attempt(user_id, started_at);
COMMIT;
