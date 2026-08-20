---
id: F-001-001-virtual-economy-ledger
parent_epic: E-001-doca-coin-hub
owner_skill: sophia-product-manager
---

# Feature: Virtual Economy & Multi-Tenant Ledger

## 1. Behavior & Specifications
*   **Inflow (Recharge)**: User selects coin package $\rightarrow$ Order created (PENDING) $\rightarrow$ User pays via ZaloPay QR / App-to-App $\rightarrow$ Webhook verifies HMAC $\rightarrow$ BullMQ worker credits wallet balance and writes `coin_transactions` (`RECHARGE`).
*   **Outflow (Spend)**: User requests feature unlock $\rightarrow$ API checks balance with row lock $\rightarrow$ Deducts coins $\rightarrow$ Writes `coin_transactions` (`SPEND`).
