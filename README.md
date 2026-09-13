# Cyber Knowledge Base

A Markdown-first technical knowledge base built with **Material for MkDocs** and deployable to **GitHub Pages**.

## Quick start (Windows PowerShell)

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r requirements.txt
mkdocs serve
```

Then open:

`http://127.0.0.1:8000`

## Before publishing

1. Edit `mkdocs.yml`.
2. Replace the placeholder GitHub username/repository values.
3. Add your own content under `docs/`.
4. Never publish passwords, tokens, private keys, employer/client secrets, or unredacted sensitive screenshots.
5. Run:

```powershell
mkdocs build --strict
```

## Deployment

The included GitHub Actions workflow builds the site from `main` and deploys it to GitHub Pages.

In GitHub:

**Repository → Settings → Pages → Build and deployment → Source → GitHub Actions**
