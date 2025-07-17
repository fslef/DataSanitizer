# Development Workflow

We use [GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow) for all code changes. All development happens through pull requests.

```mermaid
gitGraph
  commit id: "Initial commit" tag: "v0.1.0"
  checkout main
  branch feat/feature-1
  checkout feat/feature-1
  commit
  checkout main
  branch feat/feature-2
  checkout feat/feature-2
  commit
  checkout main
  merge feat/feature-2
  commit tag: "v0.2.0"
  checkout main
  merge feat/feature-1
  commit id: "v0.3.0-Preview-1"
  commit tag: "v0.3.0"
  checkout main
  branch fix/issue-1
  checkout fix/issue-1
  commit
  checkout main
  merge fix/issue-1
  commit tag: "v0.3.1"
```

## Branching Strategy
- **main**: Stable, production-ready code.
- **feat/**: New features.
- **fix/**: Bug fixes.
- **docs/**: Documentation updates.

## Pull Requests
- All changes must go through a pull request.
- Ensure your branch is up to date with `main` before opening a PR.
- Reference related issues in your PR description.
- Use clear, descriptive titles and summaries.
- Request reviews from relevant team members.
- Address review comments promptly.
- Squash and rebase as needed before merging.
