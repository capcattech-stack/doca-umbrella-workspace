# Database & Migration Engineering Standards

## 1. Strict Ban on Auto-Synchronization (`synchronize: true`)
- **NEVER** set `synchronize: true` in TypeORM or any ORM across all environments (including local development, staging, and production).
- Auto-sync risks dropping columns and tables during entity property refactoring, causing catastrophic data loss of customer wallets and transaction ledgers.

## 2. Mandatory Versioned Migrations
- All database schema modifications (creating tables, altering columns, data type changes, index creation, foreign keys) **MUST BE IMPLEMENTED VIA VERSIONED MIGRATION FILES**.
- Every migration file must contain both robust `up()` and `down()` methods to support seamless rollback.
- Migrations must be placed under `db/migrations` (or `src/migrations`) and executed via CLI scripts.

## 3. Financial Data Preservation & Immutability
- **NEVER** execute destructive DDL commands (`DROP TABLE`, `DROP COLUMN`) on core financial ledger tables (`wallets`, `coin_transactions`, `payment_orders`).
- If an entity property is deprecated, use soft deprecation or multi-phase non-breaking migrations.
