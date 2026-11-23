# Grupo 8 – Rede de Academias

Projeto de refatoração de banco de dados do Exercício 6, Cenário 8.

## Objetivo
Eliminar a redundância da tabela antiga de check-ins, separando alunos, planos,
matrículas, pagamentos e acessos até a Terceira Forma Normal (3FN).

## Tecnologia
- PostgreSQL
  
## Como executar
Execute os arquivos, nesta ordem, em uma conexão PostgreSQL:

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
