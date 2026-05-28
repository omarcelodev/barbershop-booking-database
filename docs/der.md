# Diagrama Entidade-Relacionamento (DER)

Representação textual do DER do sistema de agendamentos.

---

## Estrutura do Diagrama

```
┌─────────────────────────────┐
│           USUARIO           │
├─────────────────────────────┤
│ PK  id                      │
│     nome                    │
│     email UNIQUE            │
│     telefone                │
│     senha_hash              │
│     role(ENUM)              │ ──────────────────────┐
│     ativo                   │                       │
│     criadoEm                │                       ▼
│     atualizadoEm            │              ┌──────────────┐
└──────────────┬──────────────┘              │  Role(ENUM)  │
               │ 1                           ├──────────────┤
               │                             │ CLIENTE      │
               ▼ 1                           │ BARBEIRO     │
┌─────────────────────────────┐              │ ADMIN        │
│           BARBEIRO          │              └──────────────┘
├─────────────────────────────┤
│ PK  id                      │
│ FK  usuario_id UNIQUE       │
│     especialidade           │
│     ativo                   │
└──────┬───────────┬──────────┘
       │           │
       │ 1         │ 1
       │           │
       ▼ N         ▼ N
┌──────────────┐  ┌──────────────────────────┐
│    AGENDA    │  │      BARBEIRO_SERVICO     │
├──────────────┤  ├──────────────────────────┤
│ PK  id       │  │ PK  id                   │
│ FK  barb._id │  │ FK  barbeiro_id          │
│  dia_semana  │  │ FK  servico_id           │
│  hora_inicio │  └───────────┬──────────────┘
│  hora_fim    │              │ N
└──────────────┘              │
                              ▼ 1
              ┌───────────────────────────────┐
              │            SERVICO            │
              ├───────────────────────────────┤
              │ PK  id                        │
              │     nome                      │
              │     preco                     │
              │     duracao_min               │
              └──────────────┬────────────────┘
                             │ 1
                             │
                             ▼ N
┌────────────────────────────────────────────┐
│               AGENDAMENTO                  │
├────────────────────────────────────────────┤
│ PK  id                                     │
│ FK  usuario_id  ◄──── (Usuario/Cliente)    │
│ FK  barbeiro_id ◄──── (Barbeiro)           │
│ FK  servico_id  ◄──── (Servico)            │
│     data_hora_inicio                       │
│     data_hora_fim                          │
│     status(ENUM)                           │ ──────────┐
└──────────────────────────┬─────────────────┘           │
                           │ 1                            ▼
                           │                   ┌──────────────────┐
                           ▼ N                 │  Status(ENUM)    │
        ┌──────────────────────────────┐       ├──────────────────┤
        │          NOTIFICACAO         │       │ PENDENTE         │
        ├──────────────────────────────┤       │ CONFIRMADO       │
        │ PK  id                       │       │ CONCLUÍDO        │
        │ FK  agendamento_id           │       │ CANCELADO        │
        │ FK  usuario_id               │       │ REMARCADO        │
        │     canal(ENUM)              │       └──────────────────┘
        │     enviado_em               │
        │     status(ENUM)             │
        └──────────────────────────────┘
```

---

## ENUMs do Sistema

### Role (Usuario)
```
CLIENTE | BARBEIRO | ADMIN
```

### Status (Agendamento)
```
PENDENTE → CONFIRMADO → CONCLUÍDO
         ↘ CANCELADO
         ↘ REMARCADO
```

### Canal (Notificacao)
```
EMAIL | SMS | WHATSAPP
```

### Status (Notificacao)
```
PENDENTE → ENVIADO
         ↘ FALHA
```

### Dia da Semana (Agenda)
```
0 = DOMINGO
1 = SEGUNDA
2 = TERÇA
3 = QUARTA
4 = QUINTA
5 = SEXTA
6 = SÁBADO
```