---
id: ISSUES-E-001-doca-coin-hub
parent_epic: E-001-doca-coin-hub
reviewed_by: ada-qa-agent
---

# Epic Issues & Risk Log: Doca Coin Hub

## 1. Concurrency & Race Condition Risk (Double Spending)
*   **Risk:** Concurrent spend requests could result in negative wallet balances.
*   **Resolution:** Implemented PostgreSQL pessimistic row lock (`SELECT ... FOR UPDATE`) inside atomic database transactions.

## 2. Webhook Gateway Timeout
*   **Risk:** Direct synchronous ledger processing during webhook callbacks risks HTTP 504 timeouts.
*   **Resolution:** Decoupled callback acknowledgment (<50ms) using BullMQ queue and async worker.
