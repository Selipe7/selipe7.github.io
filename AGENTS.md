# Repository instructions for coding agents

This repository is a technical knowledge base built with Material for MkDocs.

## Content rules

- Put user-facing documentation under `docs/`.
- Keep pages in Markdown unless HTML is required for a Material feature.
- Prefer concise, reproducible, technically accurate procedures.
- Never invent commands, output, vulnerabilities, versions, citations, screenshots, or test results.
- If a fact cannot be verified from supplied material, mark it as needing verification.
- Never add passwords, API keys, tokens, private keys, recovery codes, confidential employer/client information, or competition secrets.
- Redact sensitive values in screenshots before adding them.
- Distinguish examples from commands actually executed.
- When documenting a lab, state the environment and date tested.

## Page structure

For lab/walkthrough pages, prefer:

1. Objective
2. Environment
3. Prerequisites
4. Procedure
5. Verification
6. Troubleshooting
7. Security notes
8. What I learned
9. References

Use `docs/resources/lab-writeup-template.md` as the default template.

## Site maintenance

- Keep `mkdocs.yml` navigation synchronized with added pages when navigation is explicit.
- Keep links relative where practical.
- Store screenshots under `docs/assets/images/<topic>/`.
- Use meaningful filenames: `ad-dns-install-server-manager.png`, not `image1.png`.
- Run `mkdocs build --strict` before considering changes complete.
- Do not edit the generated `site/` directory.
