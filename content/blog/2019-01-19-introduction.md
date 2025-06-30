+++
title = "Introduction"
description = "Reinvigorating my love of creative writing, one post at a time."

[taxonomies]
tags = ["webdev"]
categories = ["meta"]

[extra]
stylesheets = ["css/comments.css"]
+++

Welcome to my new development blog! This is a place where I can record my
thoughts on various topics, technical or otherwise. Conveying one's own thought
processes precisely and eloquently through text is a very valuable skill, and
it's one that only comes through practice.

Notice that I wrote _new_ development blog in the very first sentence of this
post. That choice of words was quite intentional. I used to maintain a
[personal WordPress blog] quite a few years ago, beginning in 2011. It was also
the place where I announced the founding of the [Amethyst] game engine project,
which happened to also be my last post to date. Crafting articles, writing
guides, and posting them for the world to see was great fun, though, and I'd
like to start doing that again.

[personal WordPress blog]: https://nullpwd.wordpress.com/
[Amethyst]: https://nullpwd.wordpress.com/2016/01/13/starting-an-open-source-project/

## A note about platforms

WordPress holds a special place in my heart as a familiar, venerable, and
flexible <abbr title="content management system">CMS</abbr> and blog platform.
but I feel as though I have outgrown it in the past few years. Underneath its
appealing interface, there is an incredible amount of hidden complexity that
sometimes rears its ugly head if you go poking around deep enough. This isn't a
bad thing, as WordPress is intended as a premier tool for crafting all sorts of
professional websites. However, I simply have no need for 99% of the features it
offers, and since I have grown increasingly comfortable working with Git and the
terminal, I would personally rather write [Markdown] in simple text files
committed to version control than have to deal with WordPress' idiosyncrasies.

[Markdown]: https://daringfireball.net/projects/markdown/syntax

As such, I have decided to re-launch my personal blog as a static site hosted on
[GitHub Pages] using [Zola] as my preferred static site generator. I chose to
use Zola over a more established tool like [Jekyll], which GitHub Pages has
native support for, because I enjoy the lack of external dependencies required
by Zola itself, the simple TOML-based configuration, and its subjectively
cleaner project layout. Plus, it's written in [Rust], a programming language
which I happen to personally enjoy.

[GitHub Pages]: https://pages.github.com/
[Zola]: https://www.getzola.org/
[Jekyll]: https://jekyllrb.com/
[Rust]: https://www.rust-lang.org/

This new blog is deployed automatically through [Travis CI] and the source code
is available as free and open source software on GitHub ([repository link]).
Feel free to peruse through the source, if you'd like. If you'd like to get in
touch with me, hit me up on any of these [social links](@/about/_index.md).

[Travis CI]: https://travis-ci.org/
[repository link]: https://github.com/ebkalderon/ebkalderon.github.io/
