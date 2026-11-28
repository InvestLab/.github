# Contributing to InvestLab

These rules apply to every repository in the organization. A repository can add its own rules in its own `CONTRIBUTING.md`, but it cannot relax these.

## Branches

`main` is protected in every repository. Nobody pushes to it directly, organization owners included; every change arrives through a pull request.

Work on a short-lived branch named `type/short-description`, where `type` is one of the commit types below and the description is a few lowercase words joined by hyphens:

```
feat/quote-polling
fix/empty-dividend-response
docs/contribution-guide
ci/arm64-image-build
```

Branches are deleted automatically after the merge.

## Commit messages

Commits follow [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/):

```
<type>(<optional scope>): <description>

<optional body>

<optional footers>
```

| Type | Use it for |
|---|---|
| `feat` | A new capability for users or other services |
| `fix` | A bug fix |
| `docs` | Documentation only |
| `refactor` | A code change that neither fixes a bug nor adds a feature |
| `test` | Adding or correcting tests |
| `ci` | Pipeline and workflow changes |
| `build` | Build system, dependencies, container images |
| `perf` | A change that makes something faster or cheaper |
| `chore` | Anything else that does not touch production code |
| `revert` | Reverting an earlier commit |

Write the description in the imperative mood and in lowercase, without a final period: `add dividend reinvestment`, not `Added dividend reinvestment.` Keep the first line under 100 characters. The scope is optional and names the area of the change, for example `feat(portfolio): ...`.

Mark a change that breaks an API or a contract with `!` after the type (`feat!: remove v1 quotes endpoint`) or with a `BREAKING CHANGE:` footer that explains what callers must do.

A `commitlint` check runs on every pull request and fails if any commit, or the pull request title, does not follow this format.

## Pull requests

- Open the pull request early, as a draft if the work is not ready, so the checks run while you work.
- Give it a Conventional Commits title. Pull requests are squash-merged, and the title becomes the single commit on `main`. The description becomes the commit body.
- Fill in the template: what changed, why, and how you tested it.
- Keep it to one change. A refactor and a feature go in separate pull requests.
- Resolve every review conversation before merging.
- Keep the branch up to date with `main`. The protection requires it, so the checks run against the code that will actually land.

While the project has a single maintainer, pull requests need no approving review. When a second maintainer joins, the rule changes to one approval.

## Definition of done

A pull request is ready to merge when:

1. All required checks pass.
2. New or changed behavior is covered by tests. Services enforce at least 80% test coverage on pull requests.
3. Documentation is updated where behavior, configuration or setup changed.
4. The diff contains no secrets, credentials, account ids or personal data.
5. You have read your own diff once more on GitHub before merging.
