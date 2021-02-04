# Personal Website

[![Build Status][gbadge]][glink] [![CC BY-SA License][lbadge]][llink]

[gbadge]: https://github.com/ebkalderon/ebkalderon.github.io/workflows/zola/badge.svg?branch=master
[glink]: https://github.com/ebkalderon/ebkalderon.github.io/actions

[lbadge]: https://img.shields.io/badge/license-CC_BY--SA-blue.svg
[llink]: https://creativecommons.org/licenses/by-sa/4.0/

This is the source code for my personal website. Built by [Zola], deployed
automatically through [GitHub Actions], and hosted on [GitHub Pages].

[Zola]: https://www.getzola.org/
[GitHub Actions]: https://github.com/features/actions
[GitHub Pages]: https://pages.github.com/

Commits pushed to the [`master`] branch of this repository are automatically
deployed to the [`gh-pages`] branch by GitHub Actions, which are then published
by GitHub Pages.

[`master`]: https://github.com/ebkalderon/ebkalderon.github.io/tree/master
[`gh-pages`]: https://github.com/ebkalderon/ebkalderon.github.io/tree/gh-pages

## Building locally

1. [Install Zola](https://www.getzola.org/documentation/getting-started/installation/)
2. `git clone --recursive https://github.com/ebkalderon/ebkalderon.github.io`
3. `cd ebkalderon.github.io`
4. `zola serve`
5. Access the site in a browser at `http://127.0.0.1:1111`.

## License

Copyright © 2021 Eyal Kalderon. All rights reserved, except for the parts
enumerated below:

* The page content, i.e. the `content` directory, is licensed under the terms of
  the [Creative Commons Attribution/ShareAlike 4.0 License][llink].

* The website source code, excluding the visual design, is licensed under the
  terms of the [MIT License](./LICENSE).
