---
id: M-001-001-coin-hub-backend
parent_epic: E-001-doca-coin-hub
owner_skill: david-systems-architect
source_path: apps/coin-hub
---

# Module: Doca Coin Hub Backend

## 1. Architecture & Responsibilities
Provides REST APIs for:
*   `WalletService`: Balance query, atomic spend, guest wallet merge.
*   `OrderService`: Package catalog, payment order dispatch (ZaloPay & Mock).
*   `WebhookController`: HMAC verification and BullMQ job dispatch.
*   `LedgerProcessor`: Worker transaction ledger bookkeeping.
*   `AdminService`: Reconciliation, manual credit, package CRUD.

```mermaid
graph LR
    API[REST Controller] --> Service[Service Layer]
    Service --> DB[(PostgreSQL)]
    Webhook[Webhook Controller] --> Queue[BullMQ]
    Queue --> Worker[Ledger Worker]
    Worker --> DB
```
