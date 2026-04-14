# Copilot Execution Brief - CI/CD Refactor and Hardening

## Context

Repository: azure-k8s-infrastructure  
Current branch: feat/aks-postgres-hardening-from-65  
Default branch: main

Goal: refactor GitHub Actions workflows to be less verbose, faster, and more reliable, while keeping current bootstrap constraints (frontend/backend apps not fully initialized yet).

## Mission

Execute this work end-to-end:

1. Create a dedicated branch from main.
2. Create a draft PR using the repository PR template.
3. Add relevant labels.
4. Start implementing the workflow changes listed below.
5. Commit in small logical chunks.

## Branch Strategy (must follow exactly)

Run:

```bash
git fetch origin
git checkout main
git pull --ff-only origin main
git checkout -b feat/ci-cd-modularization-hardening
```

If branch already exists locally, use:

```bash
git checkout feat/ci-cd-modularization-hardening
git rebase origin/main
```

## Scope of Changes

Target files:

- .github/workflows/ci.yml
- .github/workflows/deploy-dev.yml
- .github/workflows/terraform-plan.yml

### A) Make Terraform checks strict in CI

In .github/workflows/ci.yml:

1. Remove `continue-on-error: true` from Terraform format check.
2. Keep `terraform validate` blocking.
3. Keep `terraform init -backend=false` for CI compatibility.

Rationale: Terraform codebase is present and active, so formatting drift should fail PR checks.

### B) Keep backend/frontend bootstrap-friendly, but not noisy

In .github/workflows/deploy-dev.yml:

1. Keep temporary skip behavior if apps are not initialized.
2. Replace fragile file existence checks with robust shell checks:
   - For .NET projects, use `compgen -G "*.csproj" > /dev/null` in the backend working directory.
   - For frontend, check `test -f package.json`.
3. Keep output concise and explicit (skip reason in one line).

### C) Remove hidden failures where possible

In .github/workflows/ci.yml:

1. Replace broad `|| true` patterns in Ansible and Kubernetes checks with controlled logic:
   - If no files/manifests: print skip and continue.
   - If files exist and a check fails: fail job.
2. CI should not show green when a real validation fails.

### D) Add practical performance improvements

1. Add `concurrency` for workflows to cancel superseded runs on same ref:

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

2. Ensure cache is used where available:
   - Node cache already enabled in deploy-dev.yml.
   - Add .NET package cache in backend job.
   - Add Python pip cache in ansible-lint job.

### E) Keep behavior stable

1. Do not introduce destructive infra actions.
2. Do not enable real `terraform apply` if currently placeholder by design.
3. Keep current triggers unless explicitly improved with safe path filtering.

## PR Creation (Draft)

After first meaningful commit, push branch and create draft PR.

```bash
git push -u origin feat/ci-cd-modularization-hardening
```

Create draft PR with GitHub CLI:

```bash
gh pr create \
  --base main \
  --head feat/ci-cd-modularization-hardening \
  --draft \
  --title "ci(github-actions): harden and modularize CI/CD checks" \
  --body-file .github/pull_request_template.md
```

Then edit PR body to fully populate template sections with the implemented feature details.

## PR Template Content Rules

Template sections to fill:

- Troubleshooting
- PR Type
- Summary
- Description
- What's Changed
- Screen
- Will

Expected values for this work:

- PR Type: `chore`
- Summary: 1-2 lines on CI/CD hardening and reliability improvements.
- Description: context + why hidden failures were removed + caching/concurrency updates.
- What's Changed: explicit bullet list of concrete workflow edits.
- Screen: optional (N/A if none).
- Will: include follow-up if needed and issue link placeholder (`Relates to #XX`).
- Footer line: `Closes #XX` or `Fixes #XX` when issue number is known.

## Labels to Add

Apply labels that match this work:

- cicd
- github
- terraform
- testing
- enhancement
- chore

Optional based on final diff:

- ansible
- kubernetes

## Commit Plan

Use small commits, for example:

1. `ci(github-actions): make terraform fmt check blocking`
2. `ci(github-actions): stop masking ansible and kubernetes failures`
3. `ci(github-actions): add caching and concurrency controls`
4. `ci(github-actions): stabilize bootstrap checks for backend and frontend`

## Validation Checklist

Before marking PR ready:

1. Workflow YAML syntax valid.
2. No accidental broad permission escalation.
3. CI fails on real Terraform format/validation errors.
4. CI does not fail when backend/frontend projects are truly absent.
5. Logs are concise and understandable.

## Non-Goals

1. No full infra deployment redesign.
2. No migration to reusable workflows in this first pass if it adds risk.
3. No change to production deployment behavior.

## Definition of Done

Done when:

1. Dedicated branch from main exists.
2. Draft PR is opened and template is fully filled with real content.
3. Required labels are set.
4. First set of CI/CD hardening commits is pushed.
5. Pipeline behavior is stricter, less noisy, and faster where safely possible.
