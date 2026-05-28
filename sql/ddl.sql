CREATE TABLE usuario (
 id BIGSERIAL PRIMARY KEY,
 nome VARCHAR(100) NOT NULL,
 email VARCHAR(150) NOT NULL UNIQUE,
 telefone VARCHAR(20),
 senha_hash VARCHAR(255) NOT NULL,
 role role_enum NOT NULL DEFAULT 'CLIENTE',
 ativo BOOLEAN NOT NULL DEFAULT TRUE,
 criado_em TIMESTAMP NOT NULL DEFAULT NOW(),
 atualizado_em TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE barbeiro (
 id BIGSERIAL PRIMARY KEY,
 usuario_id BIGINT NOT NULL UNIQUE REFERENCES usuario(id) ON DELETE CASCADE,
 especialidade VARCHAR(150),
 ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE servico (
 id BIGSERIAL PRIMARY KEY,
 nome VARCHAR(100) NOT NULL,
 preco DECIMAL(8, 2) NOT NULL CHECK (preco >= 0),
 duracao_min INT NOT NULL CHECK (duracao_min > 0)
);

CREATE TABLE barbeiro_servico (
 id BIGSERIAL PRIMARY KEY,
 barbeiro_id BIGINT NOT NULL REFERENCES barbeiro(id) ON DELETE CASCADE,
 servico_id BIGINT NOT NULL REFERENCES servico(id) ON DELETE CASCADE,
 UNIQUE (barbeiro_id, servico_id)
);

CREATE TABLE agenda (
 id BIGSERIAL PRIMARY KEY,
 barbeiro_id BIGINT NOT NULL REFERENCES barbeiro(id) ON DELETE
CASCADE,
 dia_semana dia_semana_enum NOT NULL,
 hora_inicio TIME NOT NULL,
 hora_fim TIME NOT NULL,
 CHECK (hora_fim > hora_inicio)
);

CREATE TABLE agendamento (
 id BIGSERIAL PRIMARY KEY,
 usuario_id BIGINT NOT NULL REFERENCES usuario(id) ON DELETE RESTRICT,
 barbeiro_id BIGINT NOT NULL REFERENCES barbeiro(id) ON DELETE RESTRICT,
 servico_id BIGINT NOT NULL REFERENCES servico(id) ON DELETE RESTRICT,
 data_hora_inicio TIMESTAMP NOT NULL,
 data_hora_fim TIMESTAMP NOT NULL,
 status status_agendamento_enum NOT NULL DEFAULT 'PENDENTE',
 CHECK (data_hora_fim > data_hora_inicio)
);

CREATE TABLE notificacao (
 id BIGSERIAL PRIMARY KEY,
 agendamento_id BIGINT NOT NULL REFERENCES agendamento(id) ON DELETE CASCADE,
 usuario_id BIGINT NOT NULL REFERENCES usuario(id) ON DELETE CASCADE,
 canal canal_notificacao_enum NOT NULL,
 enviado_em TIMESTAMP,
 status status_notificacao_enum NOT NULL DEFAULT 'PENDENTE'
);

-- Buscas de agendamentos por usuario/barbeiro/status sao as mais frequentes
CREATE INDEX idx_agendamento_usuario ON agendamento(usuario_id);
CREATE INDEX idx_agendamento_barbeiro ON agendamento(barbeiro_id);
CREATE INDEX idx_agendamento_status ON agendamento(status);
CREATE INDEX idx_agendamento_data ON agendamento(data_hora_inicio);
-- Agenda consultada por barbeiro + dia ao validar disponibilidade
CREATE INDEX idx_agenda_barbeiro_dia ON agenda(barbeiro_id, dia_semana);
-- Notificacoes pendentes precisam ser localizadas rapidamente
CREATE INDEX idx_notificacao_status ON notificacao(status);
CREATE INDEX idx_notificacao_agendamento ON notificacao(agendamento_id);
