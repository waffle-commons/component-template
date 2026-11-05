# Waffle Commons - Component Template
<img src="./images/waffle-commons_logo.png" alt="Logo Waffles Commons" style="width: 25%;" /><br />
This repository is the standard starting point for every new component of the Waffle Commons ecosystem.
It carries the directory layout, the tooling configuration (Composer, PHPUnit, Mago, Psalm, Igor), the CI
pipeline (GitHub Actions) and the community files, so a new package starts green and consistent with the
others.

## What you get
- **Layout:** `src/`, `tests/` (PHPUnit 12.5 bootstrap + `AbstractTestCase`), `var/` for build artefacts.
- **Quality gates:** Mago formatter, linter, analyzer and guard with the ecosystem policy and **no
  baseline**; Igor worker-safety audit (pinned auditor version); PHPUnit with coverage.
- **CI:** one canonical `.github/workflows/main.yml`, identical in every component (`wfl ci:check`
  compares them). It skips only inside this template repository.
- **Supply chain:** Dependabot (Composer + GitHub Actions, minor/patch), CycloneDX SBOM, `composer audit`,
  Psalm taint analysis, TruffleHog secret scanning.
- **Community files:** `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, issue and PR templates.

## How to use this template

### 1. Create the component
From the umbrella repository (preferred — it also registers the submodule):
```shell
wfl new-component <PascalName> <git-url> "<one-sentence description>"
```
Or create a repository from this template on GitHub, clone it, and continue with step 2.

### 2. Configure it
```shell
./configure-component.sh <PascalName> [package-slug] "<one-sentence description>"
# e.g. ./configure-component.sh RateLimiter "Token-bucket rate limiting for the Waffle framework."
#      ./configure-component.sh OpenApi openapi "OpenAPI 3.1 generation for the Waffle framework."
```
The script replaces `{COMPONENT_NAME}` (PSR-4 segment), `{COMPONENT_SLUG}` (lowercase Composer name,
derived from the PascalCase name unless given) and `{COMPONENT_DESCRIPTION}`, installs the component
README, removes the template-only `images/`, fails if a placeholder survives, and deletes itself.

### 3. Install and prove the gates
```shell
docker exec -w /waffle-commons/<slug> waffle-dev composer install
wfl dod <slug>        # mago zero output + tests + coverage ≥ 95 % + igor 0 KO
```

### 4. Wire it into the ecosystem
- **Umbrella:** `.gitmodules` + committed gitlink, the `umbrella-ci` paths filter, git hooks
  (`scripts/install-git-hooks.sh`); `RELEASE_INCLUDE` when the component is ready to ship.
- **GitHub settings:** merge commits only (no squash, no rebase — the release wave needs every pinned
  commit on `main`), delete branch on merge, rulesets aligned (`wfl rulesets:check <slug>`).
- **Packagist:** register `waffle-commons/<slug>` before its first tag.

The full checklist lives in the umbrella's `component-scaffold` skill.

## Development tooling (Composer scripts)
Run these from the component root, inside the dev container:
- `composer install` — install dependencies.
- `composer mago` — formatter, linter, analyzer and guard. Clean means **zero output**.
- `composer tests` — PHPUnit with coverage reports in `var/data/phpunit-coverage/`.
- `composer igor` — worker-safety audit.
- `composer ci` — Mago + tests + `composer audit` + Psalm taint analysis.

## Contributing
Improvements to the template itself (tooling, structure, CI) are welcome via pull requests to
`waffle-commons/component-template`. For a component created from it, see that component's
`CONTRIBUTING.md`.

## License
This template, and components created from it by default, are licensed under the MIT License. See
[`LICENSE.md`](./LICENSE.md).
