[![Discord](https://img.shields.io/discord/755288001592033391?logo=discord)](https://discord.gg/eKgywnfXr2)
[![PHP Version Require](http://poser.pugx.org/waffle-commons/{COMPONENT_SLUG}/require/php)](https://packagist.org/packages/waffle-commons/{COMPONENT_SLUG})
[![PHP CI](https://github.com/waffle-commons/{COMPONENT_SLUG}/actions/workflows/main.yml/badge.svg)](https://github.com/waffle-commons/{COMPONENT_SLUG}/actions/workflows/main.yml)
[![codecov](https://codecov.io/gh/waffle-commons/{COMPONENT_SLUG}/graph/badge.svg)](https://codecov.io/gh/waffle-commons/{COMPONENT_SLUG})
[![Latest Stable Version](http://poser.pugx.org/waffle-commons/{COMPONENT_SLUG}/v)](https://packagist.org/packages/waffle-commons/{COMPONENT_SLUG})
[![Latest Unstable Version](http://poser.pugx.org/waffle-commons/{COMPONENT_SLUG}/v/unstable)](https://packagist.org/packages/waffle-commons/{COMPONENT_SLUG})
[![Total Downloads](https://img.shields.io/packagist/dt/waffle-commons/{COMPONENT_SLUG}.svg)](https://packagist.org/packages/waffle-commons/{COMPONENT_SLUG})
[![Packagist License](https://img.shields.io/packagist/l/waffle-commons/{COMPONENT_SLUG})](https://github.com/waffle-commons/{COMPONENT_SLUG}/blob/main/LICENSE.md)

Waffle {COMPONENT_NAME} Component
==========================

> **Release:** _unreleased_ &nbsp;|&nbsp; [`CHANGELOG.md`](./CHANGELOG.md)

{COMPONENT_DESCRIPTION}

## 📦 Installation

```bash
composer require waffle-commons/{COMPONENT_SLUG}
```

## 🧭 Architectural boundary (`mago guard`)

`Waffle\Commons\{COMPONENT_NAME}` depends only on `waffle-commons/contracts` (plus `waffle-commons/utils`
for shared primitives) and the PSR interfaces — never on a sibling component's concrete classes. Every
interface it implements lands in `waffle-commons/contracts` first.

## 🧵 Worker safety

Services are resident in FrankenPHP worker mode: no mutable state may survive a request. Anything that
holds per-request state implements `ResettableInterface` directly; `composer igor` must report 0 KO.

## 🧪 Testing

```bash
composer mago    # formatter, linter, analyzer, guard — clean means zero output
composer tests   # PHPUnit 12.5, line coverage ≥ 95 %
composer igor    # worker-safety audit
```

## 📚 Documentation

Full documentation tree: [waffle-commons/documentation](https://github.com/waffle-commons/documentation)

## 📄 License

MIT — see [`LICENSE.md`](./LICENSE.md).
