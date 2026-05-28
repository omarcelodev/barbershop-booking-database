-- 2.1 CONSULTAS DE DADOS - DQL (Data Query Language)
-- 2.1.1 LISTAR USUARIOS ATIVOS
SELECT
 id,
 nome,
 email,
 telefone,
 role,
 criado_em::DATE AS cadastrado_em
FROM usuario
WHERE ativo = TRUE
ORDER BY role, nome;

-- 2.1.2 LISTAR BARBEIROS E SUAS ESPECIALIDADES
SELECT
 b.id AS barbeiro_id,
 u.nome AS barbeiro,
 u.telefone,
 b.especialidade
FROM barbeiro b
JOIN usuario u ON u.id = b.usuario_id
WHERE b.ativo = TRUE
ORDER BY u.nome;

-- 2.1.3 LISTAR SERVICOS DISPONIVEIS COM PRECO FORMATADO
SELECT
 id,
 nome,
 TO_CHAR(preco, 'FM"R$" 999G990D00') AS preco,
 duracao_min || ' min' AS duracao
FROM servico
ORDER BY preco;

-- 2.1.4 LISTAR HORARIOS DE ATENDIMENTO DE UM BARBEIRO
SELECT
 u.nome AS barbeiro,
 a.dia_semana,
 a.hora_inicio,
 a.hora_fim
FROM agenda a
JOIN barbeiro b ON b.id = a.barbeiro_id
JOIN usuario u ON u.id = b.usuario_id
WHERE a.barbeiro_id = 1
ORDER BY
 CASE a.dia_semana
 WHEN 'SEGUNDA' THEN 1 WHEN 'TERCA' THEN 2
 WHEN 'QUARTA' THEN 3 WHEN 'QUINTA' THEN 4
 WHEN 'SEXTA' THEN 5 WHEN 'SABADO' THEN 6
 WHEN 'DOMINGO' THEN 7
 END;

-- 2.1.5 LISTAR SERVICOS OFERECIDOS POR CADA BARBEIRO
SELECT
 u.nome AS barbeiro,
 s.nome AS servico,
 s.preco,
 s.duracao_min
FROM barbeiro_servico bs
JOIN barbeiro b ON b.id = bs.barbeiro_id
JOIN usuario u ON u.id = b.usuario_id
JOIN servico s ON s.id = bs.servico_id
ORDER BY u.nome, s.preco DESC;

-- 2.1 FATURAMENTO MENSAL POR BARBEIRO
-- Receita gerada apenas por agendamentos CONCLUIDOS
SELECT
 u.nome AS barbeiro,
 TO_CHAR(ag.data_hora_inicio, 'YYYY-MM') AS mes,
 COUNT(*) AS atendimentos,
 SUM(s.preco) AS receita_bruta,
 ROUND(AVG(s.preco), 2) AS ticket_medio
FROM agendamento ag
JOIN barbeiro b ON b.id = ag.barbeiro_id
JOIN usuario u ON u.id = b.usuario_id
JOIN servico s ON s.id = ag.servico_id
WHERE ag.status = 'CONCLUIDO'
GROUP BY u.nome, TO_CHAR(ag.data_hora_inicio, 'YYYY-MM')
ORDER BY mes DESC, receita_bruta DESC;

-- 2.1.7 RANKING DE BARBEIROS POR DESEMPENHO
SELECT
 RANK() OVER (ORDER BY COUNT(*) DESC) AS posicao,
 u.nome AS barbeiro,
 b.especialidade,
 COUNT(*) AS total_concluidos,
 SUM(s.preco) AS receita_total,
 ROUND(AVG(s.preco), 2) AS ticket_medio,
 COUNT(*) FILTER (WHERE ag.status = 'CANCELADO') AS cancelamentos
FROM agendamento ag
JOIN barbeiro b ON b.id = ag.barbeiro_id
JOIN usuario u ON u.id = b.usuario_id
JOIN servico s ON s.id = ag.servico_id
GROUP BY u.nome, b.especialidade
ORDER BY total_concluidos DESC;

-- 2.1.8 ANALISE DE SERVICOS - DESEMPENHO E RECEITA
SELECT
 s.nome AS servico,
 TO_CHAR(s.preco, 'FM"R$" 999G990D00') AS preco_unitario,
 COUNT(*) AS total_agendamentos,
 COUNT(*) FILTER (WHERE ag.status = 'CONCLUIDO') AS concluidos,
 COUNT(*) FILTER (WHERE ag.status = 'CANCELADO') AS cancelados,
 SUM(s.preco) FILTER (WHERE ag.status = 'CONCLUIDO') AS receita_gerada,
 ROUND(
 100.0 * COUNT(*) FILTER (WHERE ag.status = 'CONCLUIDO') / COUNT(*), 1
 ) AS taxa_conclusao_pct
FROM agendamento ag
JOIN servico s ON s.id = ag.servico_id
GROUP BY s.id, s.nome, s.preco
ORDER BY total_agendamentos DESC;

-- 2.1.9 RANKING DE CLIENTES POR GASTO E FREQUENCIA
SELECT
 RANK() OVER (ORDER BY COUNT(*) DESC) AS posicao,
 u.nome AS cliente,
 u.email,
 COUNT(*) AS total_agendamentos,
 COUNT(*) FILTER (WHERE ag.status = 'CONCLUIDO') AS concluidos,
 COUNT(*) FILTER (WHERE ag.status = 'CANCELADO') AS cancelados,
 SUM(s.preco) FILTER (WHERE ag.status = 'CONCLUIDO') AS total_gasto,
 MAX(ag.data_hora_inicio) AS ultimo_agendamento
FROM agendamento ag
JOIN usuario u ON u.id = ag.usuario_id
JOIN servico s ON s.id = ag.servico_id
GROUP BY u.id, u.nome, u.email
ORDER BY total_agendamentos DESC
LIMIT 10;

-- 2.12 DASHBOARD GERAL - RESUMO EXECUTIVO DA BARBEARIA
SELECT 'Total de clientes ativos' AS metrica,
COUNT(*)::TEXT AS valor
 FROM usuario WHERE role = 'CLIENTE' AND ativo = TRUE
UNION ALL
SELECT 'Barbeiros em atividade', COUNT(*)::TEXT
 FROM barbeiro WHERE ativo = TRUE
UNION ALL
SELECT 'Servicos no catalogo', COUNT(*)::TEXT
 FROM servico
UNION ALL
SELECT 'Agendamentos concluidos', COUNT(*)::TEXT
 FROM agendamento WHERE status = 'CONCLUIDO'
UNION ALL
SELECT 'Agendamentos cancelados', COUNT(*)::TEXT
 FROM agendamento WHERE status = 'CANCELADO'
UNION ALL
SELECT 'Agendamentos futuros (confirmados/pendentes)', COUNT(*)::TEXT
 FROM agendamento
 WHERE status IN ('CONFIRMADO','PENDENTE') AND data_hora_inicio > NOW()
UNION ALL
SELECT 'Receita total (concluidos)',
 'R$ ' || SUM(s.preco)::TEXT
 FROM agendamento ag
 JOIN servico s ON s.id = ag.servico_id
 WHERE ag.status = 'CONCLUIDO'
UNION ALL
SELECT 'Notificacoes com falha pendentes', COUNT(*)::TEXT
 FROM notificacao WHERE status = 'FALHA';