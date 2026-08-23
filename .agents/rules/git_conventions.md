# Git Conventions & Workflow Safety Rules

## 1. Strict Commit & Push Boundary (Zero Autonomous Push)
*   **NEVER automatically `git push` to `origin`:** Remote `origin` is the authoritative safety anchor used for clean rollbacks and disaster recovery.
*   **NEVER automatically `git commit` without explicit instruction:** Even after completing code, tests, or documentation, changes MUST remain local in the working directory until the human operator explicitly requests a commit or push.
*   **Explicit Human Trigger Only:** Only run `git commit` or `git push` when the user explicitly instructs (e.g., *"Hãy commit code"*, *"Push lên origin dùm mình"*).
