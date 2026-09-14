# Banco SQLite

Arquivos:

- `schema.sql`: tabelas, índices, chaves estrangeiras, constraints e triggers.
- `seed.sql`: dados de teste reproduzíveis.
- `import_index_questions.mjs`: extrai o array `questionsData` do frontend e gera SQL de importação.
- `bancoquestoes.db`: banco SQLite gerado a partir dos dois scripts.

Para recriar o banco:

```bash
rm -f database/bancoquestoes.db
sqlite3 database/bancoquestoes.db < database/schema.sql
sqlite3 database/bancoquestoes.db < database/seed.sql
```

Para substituir os dados de exemplo pelas questões do protótipo legado:

```bash
node database/import_index_questions.mjs | sqlite3 database/bancoquestoes.db
```

O importador legado lê um `questionsData` embutido no frontend. Depois da migração para React, o arquivo `frontend/simulador.html` passou a ser apenas a entrada da aplicação; para reconstruir o simulado a partir das questões já catalogadas, use:

```bash
sqlite3 database/bancoquestoes.db < database/rebuild_simulation.sql
```

Para consultar as questões catalogadas:

```sql
SELECT q.id, q.statement, s.name AS subject, q.difficulty
FROM question q
JOIN question_subject qs ON qs.question_id = q.id
JOIN subject s ON s.id = qs.subject_id
WHERE q.status = 'published';
```

O fluxo esperado pela API é criar uma questão como `draft`, inserir suas alternativas e assuntos e, somente então, alterar o status para `published`. O trigger de publicação rejeita questões que não tenham 4 ou 5 alternativas, exatamente uma alternativa correta ou nenhum assunto.