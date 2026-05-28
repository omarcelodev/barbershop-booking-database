# Entidades e Atributos

Descrição de cada entidade do banco de dados, seus atributos e responsabilidades no sistema.

---

## 1. Usuario

Armazena todos os usuários do sistema, independentemente do papel exercido — cliente, barbeiro ou administrador. A diferenciação de papéis é feita pelo atributo `role`.

O atributo `ativo` permite desativar contas sem exclusão imediata, viabilizando, por exemplo, a remoção automática de contas inativas há mais de dois anos.

| Atributo | Tipo | Descrição |
|---|---|---|
| `id` | BIGINT / UUID | Identificador único do usuário |
| `nome` | VARCHAR(100) | Nome completo |
| `email` | VARCHAR(150) | E-mail utilizado no login (UNIQUE) |
| `telefone` | VARCHAR(20) | Contato telefônico |
| `senha_hash` | VARCHAR(255) | Senha criptografada |
| `role` | ENUM | Papel: `CLIENTE`, `BARBEIRO` ou `ADMIN` |
| `ativo` | BOOLEAN | Indica se a conta está ativa |
| `criadoEm` | TIMESTAMP | Data e hora de criação do registro |
| `atualizadoEm` | TIMESTAMP | Data e hora da última atualização |

---

## 2. Barbeiro

Entidade extensão de `Usuario`, com relacionamento 1:1. Representa dados específicos de um profissional da barbearia, como especialidade (ex.: Low Fade, Corte Social, Barba).

> O atributo `ativo` aqui indica disponibilidade para atendimento — diferente do `ativo` em `Usuario`, que indica se a conta existe no sistema.

| Atributo | Tipo | Descrição |
|---|---|---|
| `id` | BIGINT / UUID | Identificador único do barbeiro |
| `usuario_id` | FK → Usuario | Referência ao usuário correspondente (1:1) |
| `especialidade` | VARCHAR(150) | Especialidades do profissional |
| `ativo` | BOOLEAN | Indica se o barbeiro está disponível para atendimento |

---

## 3. Servico

Define os serviços oferecidos pela barbearia (ex.: corte de cabelo, barba, sobrancelha, pintura). Possui relacionamento N:N com `Barbeiro`, originando a tabela associativa `Barbeiro_Servico`.

| Atributo | Tipo | Descrição |
|---|---|---|
| `id` | BIGINT / UUID | Identificador único do serviço |
| `nome` | VARCHAR(100) | Nome do serviço (ex.: Corte de Cabelo) |
| `preco` | DECIMAL(8,2) | Valor cobrado pelo serviço |
| `duracao_min` | INT | Duração estimada em minutos |

---

## 4. Agenda

Define a jornada de trabalho de cada barbeiro, determinando os dias e horários em que ele está disponível. É com base nessa entidade que o sistema valida se um horário solicitado está dentro da disponibilidade do profissional.

| Atributo | Tipo | Descrição |
|---|---|---|
| `id` | BIGINT / UUID | Identificador único da entrada de agenda |
| `barbeiro_id` | FK → Barbeiro | Referência ao barbeiro proprietário da agenda |
| `dia_semana` | ENUM / INT | Dia da semana (0 = Domingo ... 6 = Sábado) |
| `hora_inicio` | TIME | Horário de início do expediente |
| `hora_fim` | TIME | Horário de término do expediente |

---

## 5. Agendamento

Registra cada agendamento realizado por um cliente, associando-o ao barbeiro escolhido e ao serviço solicitado. O campo `status` permite acompanhar o ciclo de vida completo do atendimento.

| Atributo | Tipo | Descrição |
|---|---|---|
| `id` | BIGINT / UUID | Identificador único do agendamento |
| `usuario_id` | FK → Usuario | Cliente que realizou o agendamento |
| `barbeiro_id` | FK → Barbeiro | Barbeiro responsável pelo atendimento |
| `servico_id` | FK → Servico | Serviço a ser realizado |
| `data_hora_inicio` | TIMESTAMP | Data e hora de início do atendimento |
| `data_hora_fim` | TIMESTAMP | Data e hora prevista de término |
| `status` | ENUM | `PENDENTE`, `CONFIRMADO`, `CONCLUÍDO`, `CANCELADO`, `REMARCADO` |

---

## 6. Notificacao

Registra o envio de notificações relacionadas a um agendamento. Garante rastreabilidade e subsidia reenvios automáticos em caso de falha.

| Atributo | Tipo | Descrição |
|---|---|---|
| `id` | BIGINT / UUID | Identificador único da notificação |
| `agendamento_id` | FK → Agendamento | Agendamento ao qual a notificação se refere |
| `usuario_id` | FK → Usuario | Destinatário da notificação |
| `canal` | ENUM | Canal de envio: `EMAIL`, `SMS` ou `WHATSAPP` |
| `enviado_em` | TIMESTAMP | Data e hora do envio efetivo |
| `status` | ENUM | `PENDENTE`, `ENVIADO` ou `FALHA` |

---

## Tabela Associativa

### Barbeiro_Servico

Resolve o relacionamento N:N entre `Barbeiro` e `Servico`. Um barbeiro pode dominar múltiplos serviços, e um serviço pode ser executado por múltiplos barbeiros.

| Atributo | Tipo | Descrição |
|---|---|---|
| `id` | BIGINT / UUID | Identificador único |
| `barbeiro_id` | FK → Barbeiro | Referência ao barbeiro |
| `servico_id` | FK → Servico | Referência ao serviço |