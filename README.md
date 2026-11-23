# Grupo 8 – Rede de Academias

Projeto de refatoração de banco de dados do Exercício 6, Cenário 8.

## Objetivo
Eliminar a redundância da tabela antiga de check-ins, separando alunos, planos,
matrículas, pagamentos e acessos até a Terceira Forma Normal (3FN).

## Tecnologia
- PostgreSQL

## Estrutura
- `sql/01_estrutura_antiga.sql`: cria a tabela legada e insere 10 registros de exemplo.
- `sql/02_novo_modelo.sql`: cria as cinco tabelas normalizadas e os índices.
- `sql/03_migracao_dados.sql`: transfere os dados do legado para o novo modelo.
- `sql/04_testes_qualidade.sql`: executa consultas de verificação e testes de restrições.

## Como executar
Execute os arquivos, nesta ordem, em uma conexão PostgreSQL:

1. `sql/01_estrutura_antiga.sql`
2. `sql/02_novo_modelo.sql`
3. `sql/03_migracao_dados.sql`
4. `sql/04_testes_qualidade.sql`

Os scripts criam e utilizam o schema `academia`.

## Resultados esperados dos dados de exemplo
- 10 registros na tabela legada e 10 na nova tabela `checkin`.
- Nenhum CPF duplicado.
- Nenhum check-in órfão.
- Bruno Lima aparece com pagamento atrasado.
- Frequência: Ana Souza 4; Bruno Lima 2; Carla Mendes 2; Diego Alves 2.

**Atenção:** estes são resultados esperados dos dados de exemplo incluídos nos scripts.
A dupla deve executar os arquivos no PostgreSQL e conferir os resultados reais antes
de marcar os testes como concluídos.
