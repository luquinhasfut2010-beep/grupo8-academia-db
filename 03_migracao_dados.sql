-- GRUPO 8 - CENARIO 8: REDE DE ACADEMIAS
-- PostgreSQL
-- Arquivo 03: migra os dados do legado para o modelo normalizado.
-- Execute depois dos arquivos 01 e 02.

SET search_path TO academia, public;

-- 1. Cadastro único de alunos.
INSERT INTO aluno (nome, cpf, telefone)
SELECT DISTINCT ON (cpf)
       nome_aluno, cpf, telefone
FROM checkins
ORDER BY cpf, checkin_id;

-- 2. Cadastro único de planos.
INSERT INTO plano (nome_plano, valor_mensal)
SELECT nome_plano, MAX(valor_mensal)
FROM checkins
GROUP BY nome_plano
ORDER BY nome_plano;

-- 3. Uma matrícula para cada aluno, associada ao seu plano.
INSERT INTO matricula (aluno_id, plano_id, data_inicio, status)
SELECT a.aluno_id,
       p.plano_id,
       MIN(c.data_hora)::date,
       'ATIVA'
FROM checkins c
JOIN aluno a ON a.cpf = c.cpf
JOIN plano p ON p.nome_plano = c.nome_plano
GROUP BY a.aluno_id, p.plano_id;

-- 4. Um pagamento por matrícula e competência.
-- DISTINCT evita copiar o mesmo pagamento repetido em cada check-in.
INSERT INTO pagamento
(matricula_id, competencia, valor_cobrado, data_vencimento,
 data_pagamento, status_pagamento)
SELECT m.matricula_id,
       c.competencia,
       MAX(c.valor_mensal),
       MAX(c.data_vencimento),
       MAX(c.data_pagamento),
       MAX(c.status_pagamento)
FROM checkins c
JOIN aluno a ON a.cpf = c.cpf
JOIN matricula m ON m.aluno_id = a.aluno_id
GROUP BY m.matricula_id, c.competencia;

-- 5. Migração dos dez eventos de entrada, sem repetir dados cadastrais.
INSERT INTO checkin (matricula_id, data_hora)
SELECT m.matricula_id, c.data_hora
FROM checkins c
JOIN aluno a ON a.cpf = c.cpf
JOIN matricula m ON m.aluno_id = a.aluno_id
ORDER BY c.checkin_id;

-- Resumo da migração.
SELECT
    (SELECT COUNT(*) FROM checkins) AS registros_legado,
    (SELECT COUNT(*) FROM checkin) AS registros_novo_checkin,
    (SELECT COUNT(*) FROM aluno) AS total_alunos,
    (SELECT COUNT(*) FROM plano) AS total_planos,
    (SELECT COUNT(*) FROM matricula) AS total_matriculas,
    (SELECT COUNT(*) FROM pagamento) AS total_pagamentos;
