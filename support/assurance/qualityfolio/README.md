<p align="center">
  <a href="https://demo.qualityfolio.dev/">
    <img src="assets/qualityfolio-logo.png" alt="QualityFolio" width="500">
  </a>
</p>

<p align="center">
  <em>Write tests like a human. Parse them like a machine. No schemas. No lock-in. Just Markdown, Git, and your damn test cases.</em>
</p>

<p align="center">
  <a href="https://www.linkedin.com/company/programmablemd"><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn"></a>
  <a href="https://x.com/programmablemd"><img src="https://img.shields.io/badge/X-000000?style=for-the-badge&logo=x&logoColor=white" alt="X"></a>
  <a href="https://discord.gg/programmablemd"><img src="https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white" alt="Discord"></a>
  <a href="https://docs.programmablemd.com"><img src="https://img.shields.io/badge/Docs-4285F4?style=for-the-badge&logo=googledocs&logoColor=white" alt="Docs"></a>
</p>

**QualityFolio** is a flexible test authoring framework powered by **Spry's Axiom pattern**. Author plain, human-friendly Markdown for tests that can be parsed into any structure later. Start simple, scale infinitely.

## ✨ Why QualityFolio?

- ✍️ **Write Naturally** - Use Markdown the way you already do
- 🎯 **Schema-Free** - No upfront structure required. Apply schemas at query time
- 📊 **Infinite Flexibility** - Scale from 2 to 6 heading levels as your project grows
- 🔄 **Git-First** - Version control your tests like code
- 🚀 **Auto-Discovery** - Let the parser figure out your structure, or define it yourself
- 📈 **Built-in Dashboard** - Generate test management dashboards with metrics & traceability

## 🚀 Quick Start

**3 simple rules:**

1. Use headings to _suggest_ structure (none are required)
2. Use GFM tasks (`- [ ]`, `- [x]`) for steps and expectations
3. Add metadata with `@key value` annotations or YAML/JSON blocks

**That's it.** The parser handles the rest.

### 🎯 What Do You Want To Do?

1. **📖 [Learn the patterns](#-authoring-patterns)** - See examples from simple to complex
2. **🚀 [Start building](#-getting-started)** - Generate your database & dashboard
3. **📚 [See examples](#-example-files)** - View real test artifacts
4. **🔧 [Get help](#-troubleshooting)** - Common issues & solutions

---

## 🎓 How It Works

### The Axiom Pattern Philosophy

Teams start simple and grow complexity over time. **Spry's Axiom pattern** supports all scales equally:

| Project size | Typical content you write                                     | Example mapping (later at query time)                                                                                                                                                           |
| ------------ | ------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Small        | project or plan → case (+ steps) → evidence                   | `{ heading[depth="1"]: "project", heading[depth="2"]: "case", heading[depth="3"]: "evidence" }` or `{ heading[depth="1"]: "plan", heading[depth="2"]: "case", heading[depth="3"]: "evidence" }` |
| Medium       | project → suite → case (+ steps) → evidence                   | `{ heading[depth="1"]: "project", heading[depth="2"]: "suite", heading[depth="3"]: "case", heading[depth="4"]: "evidence" }`                                                                    |
| Large        | project → plan → suite → case (+ steps) → evidence            | `{ heading[depth="1"]: "project", heading[depth="2"]: "plan", heading[depth="3"]: "suite", heading[depth="4"]: "case", heading[depth="5"]: "evidence" }`                                        |
| Complex      | project → strategy → plan → suite → case (+ steps) → evidence | `{ heading[depth="1"]: "project", heading[depth="2"]: "strategy", heading[depth="3"]: "plan", heading[depth="4"]: "suite", heading[depth="5"]: "case", heading[depth="6"]: "evidence" }`        |

> You decide the depth; **Spry's Axiom pattern** will parse headings, but role names are only applied later.

## 📝 Authoring Patterns

Pick one to start, mix and match as you grow. All patterns work seamlessly together.

### 🌱 Pattern 1: Small (project/plan + cases + evidence)

````md
---
doc-classify:
  - select: heading[depth="1"]
    role: project
  - select: heading[depth="2"]
    role: case
  - select: heading[depth="3"]
    role: evidence
---

# <Your Project or Test Plan Title>

@id <optional-stable-id>

Context One or two sentences that explain scope.

## Reset password works

@id <test-case-id>

```yaml HFM
doc-classify:
requirementID: <requirement-id>
Tags: [tag 1, tag 2]
```

Short narrative of the scenario.

Steps

- [ ] Open "Forgot Password"
- [ ] Submit email
- [x] Receive reset email
- [ ] Set a new password

Expected

- [x] Confirmation screen
- [ ] Login with new password succeeds

### Evidence

@id <add an id to refer this evidence>

```yaml HFM
doc-classify:
cycle: <test-cycle-number>
assignee: Sarah Johnson
env: qa
status: passed
```

- [Run log](./evidence/TC-LOGIN-0001/1.1/run.auto.md)
- [Response JSON](./evidence/TC-LOGIN-0001/1.1/result.auto.json)
````

> Parse-time: 3 headings.
> Query-time: map `{ heading[depth="1"]: "project", heading[depth="2"]: "case", heading[depth="3"]: "evidence" }`.

### 📦 Pattern 2: Medium (project + suite → case + evidence)

```md
---
doc-classify:
  - select: heading[depth="1"]
    role: project
  - select: heading[depth="2"]
    role: suite
  - select: heading[depth="3"]
    role: case
  - select: heading[depth="4"]
    role: evidence
---

# <Your Project or Test Plan Title>

@id <optional-stable-id>

Context One or two sentences that explain scope.

## Authentication Suite

@id <test-suite-id>

Context One or two sentences that explain the test suite.

### Valid login

@id <test-case-id>

Steps

- [ ] Enter valid credentials
- [x] Submit

Expected

- [ ] Redirect to dashboard

#### Evidence

- Screenshot
- Test execution result

### Logout vallidation

@id <test-case-id>

Steps

- [ ] Click profile menu
- [ ] Click "Sign out"

Expected

- [ ] Return to sign-in

#### Evidence

- Screenshot
- Test execution result
```

> Parse-time: 4 headings.
> Query-time mapping: `{ heading[depth="1"]: "project", heading[depth="2"]: "suite", heading[depth="3"]: "case", heading[depth="4"]: "evidence" }` or
> `{ heading[depth="1"]: "plan", heading[depth="2"]: "suite", heading[depth="3"]: "case", heading[depth="4"]: "evidence" }` - your choice.

### 🏢 Pattern 3: Large (project → plan → suite → case + evidence)

````md
---
doc-classify:
  - select: heading[depth="1"]
    role: project
  - select: heading[depth="2"]
    role: plan
  - select: heading[depth="3"]
    role: suite
  - select: heading[depth="4"]
    role: case
  - select: heading[depth="5"]
    role: evidence
---

# E2E Project Alpha

## Account Creation Plan

### Accounts & Auth Suite

@id acct-create-plan

```yaml
owner: riya@example.org
objective: Sign-up → login → profile bootstrap
```

#### New user can sign up and verify email

@id acct-signup-verify-case

Preconditions

- Mail sandbox configured in QA

Steps

- [x] Open `/signup`
- [x] Submit
- [x] Receive verification email
- [x] Click verification link
- [x] Login

Expected

- [x] User marked verified
- [x] Login succeeds

##### Evidence

- [Run log](./evidence/TC-LOGIN-0001/1.1/run.auto.md)
- [Verification email JSON](./evidence/TC-LOGIN-0001/1.1/result.auto.json)
````

> Parse-time: 5 headings.
> Query-time mapping commonly used for this depth:
> `{ heading[depth="1"]: "project", heading[depth="2"]: "plan", heading[depth="3"]: "suite", heading[depth="4"]: "case", heading[depth="5"]: "evidence" }`.

### 🏗️ Pattern 4: Complex (project → strategy → plan → suite → case + evidence)

````md
---
doc-classify:
  - select: heading[depth="1"]
    role: project
  - select: heading[depth="2"]
    role: strategy
  - select: heading[depth="3"]
    role: plan
  - select: heading[depth="4"]
    role: suite
  - select: heading[depth="5"]
    role: case
  - select: heading[depth="6"]
    role: evidence
---

# E2E Project Alpha

## Project Strategy

### Account Creation Plan

@id acct-create-plan

```yaml
owner: riya@example.org
objective: Sign-up → login → profile bootstrap
```

#### Accounts & Auth Suite

##### New user can sign up and verify email

@id acct-signup-verify-case

Preconditions

- Mail sandbox configured in QA

Steps

- [x] Open `/signup`
- [x] Submit
- [x] Receive verification email
- [x] Click verification link
- [x] Login

Expected

- [x] User marked verified
- [x] Login succeeds

###### Evidence

- [Run log](./evidence/TC-LOGIN-0001/1.1/run.auto.md)
- [Verification email JSON](./evidence/TC-LOGIN-0001/1.1/result.auto.json)
````

> Parse-time: 6 headings.
> Query-time mapping commonly used for this depth:
> `{ heading[depth="1"]: "project", heading[depth="2"]: "strategy", heading[depth="3"]: "plan", heading[depth="4"]: "suite", heading[depth="5"]: "case", heading[depth="6"]: "evidence" }`.

## 🏷️ Metadata: Annotations & Code Blocks

- Annotations: any line like `@key value` in a heading’s _own section_ (before child headings).
- Fenced code blocks: use `yaml`, `json`, or `json5` for structured metadata;
  captured with line numbers.

Examples:

````md
@id acct-lockout-case @severity critical @component auth

```yaml
owner: riya@example.org
env: qa
objective: Lockout policy & reset email
```

```json5
{
  notes: "Payment sandbox intermittently 502s",
  linked_issues: ["CHECKOUT-231"],
}
```
````

> Annotations do not inherit to children - add where you want them to apply.

## ✅ Steps & Expectations (GFM Tasks)

Use checkboxes to make steps and expected results machine-readable:

```md
Steps

- [x] Navigate to `/login`
- [x] Enter valid credentials
- [x] Provide MFA code
- [x] Redirect to `/home`

Expected

- [x] Session cookie set
- [x] CSRF token present
- [x] Home shows display name
```

> Spry's Axiom pattern extracts each item with `checked` state, the text, and precise line numbers.

## 📄 Frontmatter (Optional)

If you like, top-of-file frontmatter is parsed:

```md
---
doc-classify:
  - select: heading[depth="1"]
    role: project
  - select: heading[depth="2"]
    role: strategy
  - select: heading[depth="3"]
    role: plan
  - select: heading[depth="4"]
    role: suite
  - select: heading[depth="5"]
    role: case
  - select: heading[depth="6"]
    role: evidence
---
```

> Frontmatter errors are recorded as issues (warning), not fatal.

## 📁 File & Folder Naming

**Recommended conventions** (not required - use what fits your team):

- Use lowercase with hyphens: `account-creation-plan.md`, `mobile-auth-login.case.md`.
- Keep evidence near the doc for easy links: `./evidence/...`.
- Typical repo layout (optional; use what fits your team):

```
ASSURANCE-PRIME/
├── support/
│   └── assurance/
│       └── qualityfolio/
│           ├── evidence/
│           │   ├── TC-GLUE-001/
│           │   │   └── 1.1/
│           │   │       ├── result.auto.json
│           │   │       └── run.auto.md
│           │   └── TC-GLUE-002/
│           │       └── 1.1/
│           │           ├── loginButtonClick.png
│           │           ├── result.auto.json
│           │           └── run.auto.md
│           ├── sqlpage/
│           │   └── sqlpage.json                  # runtime configuration file for SQLPage
│           ├── test-artifacts/
│           │   └── example-artifact.md
│           ├── qualityfolio-json-etl.sql         # SQL ETL script for Qualityfolio data
│           ├── qualityfolio.md                   # SQLPage Markdown page (DB config + queries)
│           └── resource-surveillance.sqlite.db   # Database generated

```

> Remember: the parser does not require any folder layout. This is just for DX.

## 📚 Example Files

👉 **See it in action:** [View example test artifacts](https://github.com/programmablemd/assurance-prime/tree/main/support/assurance/qualityfolio/test-artifacts)

## ✅ Authoring Checklist

- [ ] Use whatever heading depth you need up to 6th level (none are required).
- [ ] Prefer GFM tasks for steps & expected results.
- [ ] Add `@id`, `@severity`, `@component`, etc. where useful.
- [ ] Use fenced YAML/JSON for richer metadata.
- [ ] Link evidence files close to the doc.
- [ ] Let schemas or discovery decide roles later.

## 🚀 Getting Started

### 📊 1. Generate SQLite Database from Test Artifacts

1. Create test artifact files and store them in a folder (for example, `test-artifacts`).
2. Execute the following commands in a terminal:

```bash
spry rb run qualityfolio.md
```

This command ingests the test artifact files and generates the SQLite database `resource-surveillance.sqlite.db`, which can be queried using any SQL editor.

### 📊 2. Generate Test Management Dashboard

1. Create test artifact files and store them in a folder (for example, `test-artifacts`).
2. Execute the following commands in a terminal:

```bash
spry rb run qualityfolio.md
spry sp spc --fs dev-src.auto --destroy-first --conf sqlpage/sqlpage.json --md qualityfolio.md --watch
```

3. In another terminal, start SQLPage:

```bash
sqlpage
```

This will launch the **Test Management Dashboard** with test metrics, requirement traceability matrix, and test cycle–wise execution views at:

```
http://localhost:9227/
```

## 🔧 Troubleshooting

- “My evidence isn’t detected” → an evidence must be a leaf heading (no deeper headings beneath it).
- “My annotations don’t show up” → ensure `@key value` is not inside a code block and is in the heading’s own section.
- “Discovery chose odd roles” → either add minimal content to meaningful ancestors (so they’re “significant”) or apply an explicit schema when querying.

## 📜 License

Your docs are yours. **Spry's Axiom pattern** is designed to read Markdown respectfully and safely.

---

**Made with 💜 for developers who love writing tests in Markdown.**
