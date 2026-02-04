# Step 1: Project setup & GitHub

## What we did

1. Created the repo structure:
   - `docs/` – architecture and step guides
   - `sql/` – Azure SQL DDL (Step 2)
   - `adf/` – ADF pipelines (Step 4)
   - `databricks/` – notebooks/jobs (Step 5)
   - `app/` – query layer (Step 6)
   - `data/raw/`, `data/curated/` – sample and curated data
   - `scripts/` – utility scripts

2. Added `.gitignore` for Python, Azure, Databricks, IDE, data files, and secrets.

3. Added `README.md` (project overview, tech stack, steps) and `docs/ARCHITECTURE.md` (data flow).

## Push this project to GitHub

### Option A: Create a new repo on GitHub, then push from your machine

1. **Create the repo on GitHub**
   - Go to [github.com/new](https://github.com/new).
   - Repository name: `order-to-cash-intelligence` (or your choice).
   - Description: e.g. "Order-to-Cash Intelligence Assistant – Azure DE + AI (ADF, Azure SQL, Databricks, RAG)".
   - Choose **Public** (or Private).
   - Do **not** initialize with README, .gitignore, or license (we already have them).

2. **Initialize git and push from your project folder**

   In a terminal, from the project root:

   ```powershell
   cd C:\Users\baner\order-to-cash-intelligence

   git init
   git add .
   git commit -m "Step 1: Project setup – structure, README, docs, .gitignore"

   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/order-to-cash-intelligence.git
   git push -u origin main
   ```

   Replace `YOUR_USERNAME` with your GitHub username. If you use SSH:

   ```powershell
   git remote add origin git@github.com:YOUR_USERNAME/order-to-cash-intelligence.git
   ```

### Option B: Use GitHub Desktop

1. In GitHub Desktop: **File → Add local repository** and select `C:\Users\baner\order-to-cash-intelligence`.
2. If it says "not a git repository," click **create a repository** and initialize there.
3. Commit all files with message: `Step 1: Project setup – structure, README, docs, .gitignore`.
4. **Publish repository** to GitHub (create new repo from the dialog).

## After pushing

- You can share the repo URL in your portfolio or resume.
- For the next step we’ll add the **data model (Azure SQL DDL)** in `sql/`.

## Questions to discuss (optional)

- Do you want the project under `C:\Users\baner` or under `OneDrive\Documents\GitHub`? (You can move the folder and re-add the remote; git will work the same.)
- Any extra folders you want (e.g. `tests/`, `infra/` for IaC)? We can add them in Step 2.
