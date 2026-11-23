-- GRUPO 8 - CENARIO 8: REDE DE ACADEMIAS
-- PostgreSQL
-- Arquivo 04: testes de qualidade e integridade.
-- Execute depois dos arquivos 01, 02 e 03.

SET search_path TO academia, public;

-- T1 - Contagem: esperado 10 no legado e 10 no novo check-in.
SELECT
    (SELECT COUNT(*) FROM checkins) AS total_legado,
    (SELECT COUNT(*) FROM checkin) AS total_novo,
    CASE
        WHEN (SELECT COUNT(*) FROM checkins) = 10
         AND (SELECT COUNT(*) FROM checkin) = 10
        THEN 'APROVADO'
        ELSE 'VERIFICAR'
    END AS resultado_t1;

-- T2 - CPF duplicado: a consulta deve retornar zero linhas.
SELECT cpf, COUNT(*) AS quantidade
FROM aluno
GROUP BY cpf
HAVING COUNT(*) > 1;

-- T3 - Check-in órfão: a consulta deve retornar zero linhas.
SELECT c.*
FROM checkin c
LEFT JOIN matricula m ON m.matricula_id = c.matricula_id
WHERE m.matricula_id IS NULL;

-- T4 - Inadimplência: Bruno Lima deve aparecer como ATRASADO.
SELECT a.nome, p.competencia, p.valor_cobrado, p.status_pagamento
FROM pagamento p
JOIN matricula m ON m.matricula_id = p.matricula_id
JOIN aluno a ON a.aluno_id = m.aluno_id
WHERE p.status_pagamento = 'ATRASADO';

-- T5 - Frequência esperada: Ana 4; Bruno 2; Carla 2; Diego 2.
SELECT a.nome, COUNT(c.checkin_id) AS total_checkins
FROM aluno a
JOIN matricula m ON m.aluno_id = a.aluno_id
LEFT JOIN checkin c ON c.matricula_id = m.matricula_id
GROUP BY a.aluno_id, a.nome
ORDER BY a.nome;

-- T7 - Teste da restrição UNIQUE do CPF.
-- O bloco tenta inserir CPF repetido e considera aprovado se o banco bloquear.
DO $$
BEGIN
    BEGIN
        INSERT INTO aluno (nome, cpf, telefone)
        VALUES ('CPF Duplicado - Teste', '11111111111', '(11) 90000-9999');

        RAISE EXCEPTION 'T7 FALHOU: o CPF duplicado foi aceito.';
    EXCEPTION
        WHEN unique_violation THEN
            RAISE NOTICE 'T7 APROVADO: CPF duplicado bloqueado pela restrição UNIQUE.';
    END;
END
$$;

-- T8 - Teste da restrição CHECK para status de pagamento.
-- O bloco tenta inserir status inválido e considera aprovado se for bloqueado.
DO $$
DECLARE
    v_matricula_id BIGINT;
BEGIN
    SELECT matricula_id INTO v_matricula_id
    FROM matricula
    ORDER BY matricula_id
    LIMIT 1;

    BEGIN
        INSERT INTO pagamento
        (matricula_id, competencia, valor_cobrado, data_vencimento, status_pagamento)
        VALUES
        (v_matricula_id, DATE '2026-12-01', 99.90, DATE '2026-12-10', 'INVALIDO');

        RAISE EXCEPTION 'T8 FALHOU: o status inválido foi aceito.';
    EXCEPTION
        WHEN check_violation THEN
            RAISE NOTICE 'T8 APROVADO: status inválido bloqueado pela restrição CHECK.';
    END;
END
$$;

-- T9 - Verificação de índice/plano de execução.
-- EXPLAIN ANALYZE executa a consulta e mostra o plano real.
EXPLAIN ANALYZE
SELECT checkin_id, matricula_id, data_hora
FROM checkin
WHERE data_hora >= TIMESTAMP '2026-11-01 00:00:00'
  AND data_hora <  TIMESTAMP '2026-12-01 00:00:00'
ORDER BY data_hora;

-- Resumo simples: as consultas T2 e T3 devem estar vazias;
-- T4 deve mostrar Bruno Lima; T5 deve mostrar 4, 2, 2 e 2.
