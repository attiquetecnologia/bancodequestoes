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

Para substituir os dados de exemplo pelas questões do protótipo:

```bash
node database/import_index_questions.mjs | sqlite3 database/bancoquestoes.db
```

O importador lê `frontend/index.html`, preserva enunciados, alternativas, gabaritos, justificativas e dicas, cria os temas encontrados nas tags e publica as 60 questões. Ele pode ser executado novamente sem duplicar as questões.

Para consultar as questões catalogadas:

```sql
SELECT q.id, q.statement, s.name AS subject, q.difficulty
FROM question q
JOIN question_subject qs ON qs.question_id = q.id
JOIN subject s ON s.id = qs.subject_id
WHERE q.status = 'published';
```

O fluxo esperado pela API é criar uma questão como `draft`, inserir suas alternativas e assuntos e, somente então, alterar o status para `published`. O trigger de publicação rejeita questões que não tenham 4 ou 5 alternativas, exatamente uma alternativa correta ou nenhum assunto.