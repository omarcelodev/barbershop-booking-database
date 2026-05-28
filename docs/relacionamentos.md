# Relacionamentos entre Entidades

Mapeamento das cardinalidades e descrição de cada relacionamento do modelo.

---

## Tabela de Relacionamentos

| Entidades | Cardinalidade | Descrição |
|---|---|---|
| `Usuario` → `Barbeiro` | **1:1** | Um usuário pode ser um barbeiro; um barbeiro está vinculado a exatamente um usuário. |
| `Barbeiro` ↔ `Servico` | **N:N** | Um barbeiro executa vários serviços; um serviço pode ser realizado por vários barbeiros. Resolvido pela tabela `Barbeiro_Servico`. |
| `Barbeiro` → `Agenda` | **1:N** | Um barbeiro possui múltiplos registros de agenda (ex.: seg a sex com horários distintos). |
| `Usuario` → `Agendamento` | **1:N** | Um cliente pode realizar vários agendamentos ao longo do tempo. |
| `Barbeiro` → `Agendamento` | **1:N** | Um barbeiro pode ter vários agendamentos em diferentes datas e horários. |
| `Servico` → `Agendamento` | **1:N** | Um serviço pode estar presente em múltiplos agendamentos. |
| `Agendamento` → `Notificacao` | **1:N** | Um agendamento pode gerar várias notificações (lembrete, confirmação, cancelamento etc.). |

---

## Detalhamento

### Usuario → Barbeiro (1:1)

Um `Usuario` com `role = BARBEIRO` possui exatamente um registro correspondente na entidade `Barbeiro`. Essa separação permite que dados genéricos de conta (email, senha, telefone) fiquem em `Usuario`, enquanto dados profissionais (especialidade, disponibilidade) ficam em `Barbeiro`.

---

### Barbeiro ↔ Servico (N:N)

Resolvido pela tabela associativa `Barbeiro_Servico`. Reflete a realidade do negócio: um barbeiro pode executar corte, barba e sobrancelha, enquanto o serviço "Corte" pode ser feito por qualquer barbeiro ativo.

```
Barbeiro ────< Barbeiro_Servico >──── Servico
```

---

### Barbeiro → Agenda (1:N)

Cada barbeiro tem múltiplos registros de agenda, um por turno ou dia da semana. Exemplo:

```
Barbeiro João
  ├── Segunda: 09:00 - 18:00
  ├── Quarta:  09:00 - 18:00
  └── Sexta:   09:00 - 14:00
```

---

### Agendamento (hub central)

A entidade `Agendamento` é o núcleo do sistema — ela conecta `Usuario` (cliente), `Barbeiro` e `Servico` em um único registro com data, hora e status.

```
Usuario ────┐
            ├──── Agendamento ──── Notificacao
Barbeiro ───┤
            │
Servico ────┘
```

---

### Agendamento → Notificacao (1:N)

Um agendamento pode disparar múltiplas notificações em diferentes momentos do seu ciclo de vida:

| Momento | Exemplo |
|---|---|
| Criação | Confirmação do agendamento |
| Véspera | Lembrete 24h antes |
| Cancelamento | Notificação de cancelamento |
| Conclusão | Avaliação do atendimento |