# Personal Website

[![Build Status][gbadge]][glink] [![MIT License][lbadge]][llink]

[gbadge]: https://github.com/ebkalderon/ebkalderon.github.io/workflows/zola/badge.svg?branch=source
[glink]: https://github.com/ebkalderon/ebkalderon.github.io/actions

[lbadge]: https://img.shields.io/badge/license-MIT-blue.svg
[llink]: ./LICENSE

This is the source code for my personal website. Built by [Zola], deployed
automatically through [GitHub Actions], and hosted on [GitHub Pages].

[Zola]: https://www.getzola.org/
[GitHub Actions]: https://github.com/features/actions
[GitHub Pages]: https://pages.github.com/

Commits pushed to the [`source`] branch of this repository are automatically
deployed to the [`master`] branch by GitHub Actions, which are then published by
GitHub Pages.

[`source`]: https://github.com/ebkalderon/ebkalderon.github.io/tree/source
[`master`]: https://github.com/ebkalderon/ebkalderon.github.io/tree/master

## Building locally

1. [Install Zola](https://www.getzola.org/documentation/getting-started/installation/)
2. `git clone https://github.com/ebkalderon/ebkalderon.github.io`
3. `cd ebkalderon.github.io`
4. `zola serve`
5. Access the site in a browser at `http://127.0.0.1:1111`.

## License

This website is free and open source software distributed under the terms of the
[MIT License](./LICENSE).
