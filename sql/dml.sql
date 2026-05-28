-- 2 admins + 6 barbeiros + 42 clientes = 50 usuarios
INSERT INTO usuario (id, nome, email, telefone, senha_hash, role, ativo,
criado_em, atualizado_em) VALUES
 (1, 'Carlos Eduardo Faria', 'carlos.admin@barbershop.com', '(62) 99101-
0001', '$2a$10$K7L9...', 'ADMIN', TRUE, '2024-01-10 08:00:00', '2024-01-10
08:00:00'),
 (2, 'Fernanda Oliveira Admin', 'fernanda.admin@barbershop.com', '(62) 99101-
0002', '$2a$10$K7L9...', 'ADMIN', TRUE, '2024-01-10 08:05:00', '2024-01-10
08:05:00'),
 (3, 'Miguel Henrique Torres', 'miguel.torres@barbershop.com', '(62) 98801-
1001', '$2a$10$K7L9...', 'BARBEIRO', TRUE, '2024-02-02 00:00:00', '2024-02-02
00:00:00'),
 (4, 'Joao Vitor Bastos', 'joao.bastos@barbershop.com', '(62) 98801-
1002', '$2a$10$K7L9...', 'BARBEIRO', TRUE, '2024-03-26 00:00:00', '2024-03-26
00:00:00'),
 (5, 'Thiago Fernandes Cruz', 'thiago.cruz@barbershop.com', '(62) 98801-
1003', '$2a$10$K7L9...', 'BARBEIRO', TRUE, '2024-02-22 00:00:00', '2024-02-22
00:00:00'),
 (6, 'Rodrigo Assis Melo', 'rodrigo.melo@barbershop.com', '(62) 98801-
1004', '$2a$10$K7L9...', 'BARBEIRO', TRUE, '2024-03-31 00:00:00', '2024-03-31
00:00:00'),
 (7, 'Felipe Augusto Neto', 'felipe.neto@barbershop.com', '(62) 98801-
1005', '$2a$10$K7L9...', 'BARBEIRO', TRUE, '2024-01-31 00:00:00', '2024-01-31
00:00:00'),
 (8, 'Anderson Lima Souza', 'anderson.souza@barbershop.com', '(62) 98801-
1006', '$2a$10$K7L9...', 'BARBEIRO', TRUE, '2024-03-04 00:00:00', '2024-03-04
00:00:00'),
 (9, 'Bernardo Melo', 'bernardo.melo9@email.com', '(62) 99574-
1009', '$2a$10$K7L9...', 'CLIENTE', TRUE, '2024-06-23 00:00:00', '2024-06-23
00:00:00'),
 -- ... +40 clientes seguindo o mesmo padrão
 ;

 INSERT INTO barbeiro (id, usuario_id, especialidade, ativo) VALUES
 (1, 3, 'Low Fade, Corte Social', TRUE),
 (2, 4, 'High Fade, Barba Degrade', TRUE),
 (3, 5, 'Corte Navalhado, Platinado', TRUE),
 (4, 6, 'Corte Infantil, Relaxamento', TRUE),
 (5, 7, 'Barba Completa, Pigmentacao', TRUE),
 (6, 8, 'Undercut, Corte Feminino', FALSE);

INSERT INTO servico (id, nome, preco, duracao_min) VALUES
 (1, 'Corte de Cabelo', 35.00, 30),
 (2, 'Barba Completa', 25.00, 25),
 (3, 'Corte + Barba', 55.00, 50),
 (4, 'Sobrancelha', 15.00, 15),
 (5, 'Platinado / Coloracao', 120.00, 90),
 (6, 'Pigmentacao de Barba', 40.00, 30);

 INSERT INTO barbeiro_servico (id, barbeiro_id, servico_id) VALUES
 (1, 1,1),(2, 1,2),(3, 1,3),(4, 1,4),
 (5, 2,1),(6, 2,3),(7, 2,5),
 (8, 3,1),(9, 3,2),(10,3,3),(11,3,6),
 (12,4,1),(13,4,4),(14,4,5),(15,4,6),
 (16,5,1),(17,5,2),(18,5,3),(19,5,4),(20,5,6),
 (21,6,1),(22,6,2),(23,6,5);

INSERT INTO agenda (id, barbeiro_id, dia_semana, hora_inicio, hora_fim) VALUES
 (1, 1,'SEGUNDA','08:00','18:00'), (2, 1,'TERCA', '08:00','18:00'),
 (3, 1,'QUARTA', '08:00','18:00'), (4, 1,'QUINTA', '08:00','18:00'),
 (5, 1,'SEXTA', '08:00','18:00'),
 (6, 2,'SEGUNDA','09:00','19:00'), (7, 2,'TERCA', '09:00','19:00'),
 (8, 2,'QUARTA', '09:00','19:00'), (9, 2,'QUINTA', '09:00','19:00'),
 (10,2,'SEXTA', '09:00','19:00'),
 -- ... +22 registros seguindo o mesmo padrão
 ;

INSERT INTO agendamento
 (id, usuario_id, barbeiro_id, servico_id, data_hora_inicio, data_hora_fim,
status)

VALUES
 (1, 28, 5, 6, '2024-09-11 12:00', '2024-09-11 12:30', 'CONCLUIDO'),
 (2, 16, 4, 5, '2024-09-03 18:30', '2024-09-03 20:00', 'CONCLUIDO'),
 (3, 46, 2, 1, '2025-03-14 14:00', '2025-03-14 14:30', 'CONCLUIDO'),
 (4, 13, 5, 2, '2024-06-18 12:00', '2024-06-18 12:25', 'CONCLUIDO'),
 (5, 13, 1, 2, '2025-03-12 08:30', '2025-03-12 08:55', 'CONCLUIDO'),
 (6, 24, 4, 4, '2024-07-13 12:30', '2024-07-13 12:45', 'CONCLUIDO'),
 (7, 36, 4, 6, '2025-01-08 11:00', '2025-01-08 11:30', 'CONCLUIDO'),
 (8, 50, 3, 6, '2024-09-17 15:00', '2024-09-17 15:30', 'CONCLUIDO'),
 (9, 24, 1, 1, '2024-09-21 13:00', '2024-09-21 13:30', 'CONCLUIDO'),
 (10, 36, 2, 1, '2024-07-15 16:00', '2024-07-15 16:30', 'CONCLUIDO'),
 -- ... +104 registros seguindo o mesmo padrão
 ;

INSERT INTO notificacao (id, agendamento_id, usuario_id, canal, enviado_em,
status) VALUES
 (1, 1, 28, 'SMS', '2024-09-10 12:00', 'ENVIADO'),
 (2, 1, 28, 'EMAIL', '2024-09-11 10:00', 'ENVIADO'),
 (3, 2, 16, 'EMAIL', '2024-09-02 18:30', 'ENVIADO'),
 (4, 2, 16, 'EMAIL', '2024-09-03 16:30', 'ENVIADO'),
 (5, 3, 46, 'SMS', '2025-03-13 14:00', 'ENVIADO'),
 (6, 3, 46, 'EMAIL', '2025-03-14 12:00', 'ENVIADO'),
 (7, 4, 13, 'WHATSAPP', '2024-06-17 12:00', 'ENVIADO'),
 (8, 4, 13, 'EMAIL', '2024-06-18 10:00', 'ENVIADO'),
 (9, 5, 13, 'SMS', '2025-03-11 08:30', 'ENVIADO'),
 (10, 5, 13, 'WHATSAPP', '2025-03-12 06:30', 'ENVIADO'),
 -- ... +194 registros seguindo o mesmo padrão
 ;

SELECT setval('usuario_id_seq', (SELECT MAX(id) FROM usuario));
SELECT setval('barbeiro_id_seq', (SELECT MAX(id) FROM barbeiro));
SELECT setval('servico_id_seq', (SELECT MAX(id) FROM servico));
SELECT setval('barbeiro_servico_id_seq', (SELECT MAX(id) FROM
barbeiro_servico));
SELECT setval('agenda_id_seq', (SELECT MAX(id) FROM agenda));
SELECT setval('agendamento_id_seq', (SELECT MAX(id) FROM agendamento));
SELECT setval('notificacao_id_seq', (SELECT MAX(id) FROM notificacao));
COMMIT;
-- Resumo: 114 agendamentos | 204 notificacoes | 23 pares barbeiro_servico
-- CANCELADO: 16 | CONCLUIDO: 72 | CONFIRMADO: 8
-- PENDENTE: 8 | REMARCADO: 10

