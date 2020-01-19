# Personal Website

[![Build Status][tbadge]][tlink] [![CC BY-SA License][lbadge]][llink]

[tbadge]: https://api.travis-ci.org/ebkalderon/ebkalderon.github.io.svg
[tlink]: https://travis-ci.org/ebkalderon/ebkalderon.github.io

[lbadge]: https://img.shields.io/badge/license-MIT-blue.svg
[llink]: ./LICENSE

This is the source code for my personal website. Built by [Zola], deployed
automatically through [Travis CI], and hosted on [GitHub Pages].

[Zola]: https://www.getzola.org/
[Travis CI]: https://travis-ci.org/
[GitHub Pages]: https://pages.github.com/

Commits pushed to the [`source`] branch of this repository are automatically
deployed to the `master` branch by Travis CI, which are then published by GitHub
Pages.

## Building locally

1. [Install Zola](https://www.getzola.org/documentation/getting-started/installation/)
2. `git clone https://github.com/ebkalderon/ebkalderon.github.io`
3. `cd ebkalderon.github.io`
4. `zola serve`
5. Access the site in a browser at `http://127.0.0.1:1111`.

## License

This website is free and open source software distributed under the terms of the
[MIT License](./LICENSE).
