---
name: open-design
description: "Open Design MCP Server Integration Skill. Use this skill when interacting with the open-design MCP server to read/write local design files, assets, and design system variables, or when translating Figma/local design documents into clean frontend code."
disable-model-invocation: false
---

# Open Design — Local-First AI Design Integration

Use the `open-design` MCP server tools to interact with local design documents, tokens, and templates. This skill guides the agent in using Open Design as a local design-to-code compiler and integration bridge.

---

## 🧭 1. Overview of Open Design MCP Server

The `open-design` MCP server bridges local coding agents with the **Open Design Platform** (typically running as a desktop app or local daemon). It provides a local-first alternative to proprietary design-to-code cloud systems.

### Core Capabilities:
1. **Design Token Discovery:** Query local design system variables (colors, spacing, typography).
2. **Component Translation:** Extract local component templates (CSS, HTML, JSX) and compile them directly into clean production code.
3. **Asset Handling:** Fetch and export layout assets (SVGs, PNGs) from design documents to local code repositories.
4. **Local Daemon Bridge:** Communicate with the local UI dashboard running on `http://localhost:17573` (default port).

---

## 🛠️ 2. Rules of Engagement

When using Open Design MCP tools:

1. **Verify Daemon Status first:** Make sure the Open Design app is running locally on the user's macOS system.
2. **Context Alignment:** Always pull tokens and components from Open Design before generating stylesheet or component files, ensuring absolute visual fidelity to the source design.
3. **No General Assumptions:** If a token is not defined in the Open Design schema, fall back to standard Iyashikei / Cozy Earthy system colors as declared in the project's [Root README](file:///Users/macinia/Capcat%20Project/README.md).
4. **Respect Design-to-Code boundaries:** Do not attempt to write complex layout logic inside raw design files. Keep the translation clean and modular (e.g., matching React/Flutter Clean Architecture).
