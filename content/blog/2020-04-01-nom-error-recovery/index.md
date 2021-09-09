+++
title = "Error recovery with parser combinators (using nom)"
description = "A brief exploration of the paper \"Syntax error recovery in parsing expression grammars\" (2018) and a practical demonstration in code."
date = 2020-04-01
updated = 2021-02-04
aliases = ["nom-error-recovery"]

[taxonomies]
tags = ["parsers", "rust"]
categories = ["research"]
+++

As the COVID-19 pandemic continues to ravage the globe, lots of people are stuck
at home, either working remotely or sitting around without much to do. The
previous afternoon, I had stumbled across an online announcement that the
[ACM Digital Library has been made free to all to read and download][acm] to
help foster research, discovery, and learning during this time of crisis.
Feeling curious, and having previously wanted to read certain research papers
from the ACM DL previously, I took the opportunity to peruse through its library
and read as much content as I could. As I was doing so, I stumbled across a very
useful paper called [**"Syntax error recovery in parsing expression
grammars"**][paper] by (Medeiros, S. and Fabio Mascarenhas, 2018) that I would
like to share, and I'll be testing some of its concepts using a prototype parser
written in [Rust] with the help of the [`nom`] crate.

[acm]: https://www.acm.org/articles/bulletins/2020/march/dl-access-during-covid-19
[paper]: https://dl.acm.org/doi/10.1145/3167132.3167261
[Rust]: https://www.rust-lang.org
[`nom`]: https://docs.rs/nom

## Some background

Language parsing is a very broad and interesting topic, with a swathe of varying
approaches and tools to choose from depending on the requirements of the task at
hand, but the basic premise is simple: the goal of a parser is to consume some
data as input, break it down into its component parts according to some grammar,
and derive meaning or understanding from it ([wiki]). I personally happen to
enjoy working with _parsing expression grammars_ (PEGs) and _parser combinators_
when writing my own projects.

[wiki]: https://en.wikipedia.org/wiki/Parsing

In case you are not familiar, PEG is a kind of declarative formal language for
describing other languages in terms of string pattern matching. That is, PEG
allows the parser author to declare the grammar of the language they wish to
parse using sets of expressions like those shown below:

```
expr    ← sum
sum     ← product (('+' / '-') product)*
product ← value (('*' / '/') value)*
value   ← [0-9]+ / '(' expr ')'
```

These PEG rules would then be able to describe the rules to a simple arithmetic
language that behaves like this:

<style>.table-auto > table { table-layout: auto }</style>

<div class="table-auto">

Input       | Parsed syntax tree
------------|-------------------------------------------------
123         | `Value(123)`
1 + 2       | `Sum(Value(1), Value(2))`
1 + 2 * 3   | `Sum(Value(1), Product(Value(2), Value(3)))`
(1 + 2) * 3 | `Product(Sum(Value(1), Value(2)), Value(3))`

</div>

Any PEG expression can be converted directly into a [recursive descent parser],
either automatically using a parser generator or crafted by hand in the
programming language of your choice.

I really enjoy using parser combinator frameworks like [`nom`] as a nice middle
ground between the two options, since they grant you the freedom and flexibility
of writing your parser fully in the host language (in this example, Rust), but
the resulting code is succinct, fairly declarative, and looks somewhat PEG-ish,
if you tilt your head and squint hard enough.

[recursive descent parser]: https://en.wikipedia.org/wiki/Recursive_descent_parser

```rust
fn expr(input: &str) -> IResult<&str, &str> {
    sum(input)
}

fn sum(input: &str) -> IResult<&str, &str> {
    let op = alt((char('+'), char('-')));
    recognize(pair(product, many0(pair(op, product))))(input)
}

fn product(input: &str) -> IResult<&str, &str> {
    let op = alt((char('*'), char('/')));
    recognize(pair(value, many0(pair(op, value))))(input)
}

fn value(input: &str) -> IResult<&str, &str> {
    recognize(alt((digit1, delimited(char('('), expr, char(')')))))(input)
}
```

Each of the four parsers above corresponds to a PEG rule, and since each one is
represented as a pure function, they compose nicely in code and each one can
easily be tested in isolation from the others, e.g. with inline unit tests. All
in all, I enjoy working with PEG and parser combinators!

## Motivation

I've been hacking on a parser and [language server] for the [Nix programming
language] as a side project ([GitHub][nls]) for some time now, and this extended
period of being stuck at home renewed my interest in working on it. This
language server aims to supply code analysis, and auto-completion for compatible
third-party text editors and IDEs. This project has been very challenging for me
to work on, in a good way, because language servers tend to have very strict
requirements of their underlying parsers.

[language server]: https://microsoft.github.io/language-server-protocol/
[Nix programming language]: https://nixos.org/nix/
[nls]: https://github.com/ebkalderon/nix-language-server

Most compilers and static analysis tools are [batch programs] which act like a
dumb pipe, consuming source code in one end and spitting an executable out the
other (yes, incremental compilation and artifact caching bends this analogy a
bit, but the basic premise still holds). This means that their parsers and
resulting [abstract syntax trees] are optimized for very different things than
what an interactive IDE would want.

[batch programs]: https://en.wikipedia.org/wiki/Batch_program
[abstract syntax trees]: https://en.wikipedia.org/wiki/Abstract_syntax_tree

Since the user is continuously modifying the source text and entering keystrokes
into their editor, the parser providing syntax checking for their editor is very
frequently exposed to incomplete or downright invalid snippets of code more
often than not. This means that halting parsing and bailing with an error
message whenever the first error is encountered, like many traditional parsers
do, is _simply not an option_.

{{ figure(src="rust-analyzer.gif",
          alt="rust-analyzer in action"
          caption="Parser producing a best-effort syntax tree from incomplete code ([credit](https://rust-analyzer.github.io/thisweek/2020/03/16/changelog-16.html))") }}

Instead, the parser needs to be as fault-tolerant as possible, always producing
a syntax tree of some kind on every single parse and deriving as much syntactic
and semantic meaning as it can from user input, however malformed it might be.
Your editor should still be able to provide meaningful code completion, hover
documentation, go-to-definition, and symbol searching regardless of whether
there is a missing semicolon somewhere halfway down the page.

## A naive approach

When I first started working on this project, I had chosen to implement my Nix
parser in Rust using `nom` 5.0, since that was the tool I was most comfortable
using for writing parsers at the time.

As I was writing up my parsers, I very quickly realized that bailing early from
parsing with an `Err(nom::Err::Error(_))` or `Err(nom::Error::Failure(_))`
wasn't a good idea for emitting errors. The former triggers a backtrack, which I
didn't always want, and the latter would halt parsing altogether with an error,
which I never wanted. `Err(nom::Error::Incomplete(_))` sounded promising due to
the name, but it too ended up being useless given the design constraints I had
in mind. I needed some way to log that a non-fatal parse error had been
encountered and resume parsing as though nothing had happened, but
unfortunately, there seemed to be nothing in the vast `nom` parser combinator
toolbox that could help me deal with this.

Given that `nom` parser combinators are pure functions whose signatures are
structured like this:

```rust
impl Fn(Input) -> IResult<Input, Output, Error>
```

which maps to:

```rust
impl Fn(Input) -> Result<(Remaining, Output), Error>
```

I decided to carry these non-fatal parse errors through the `Output` instead of
returning them through `Result::Err(nom::Error::Error(_))` using a custom data
structure which I had named [`Partial`]. This was a monadic data structure which
was essentially:

[`Partial`]: https://github.com/ebkalderon/nix-language-server/blob/master/nix-parser/src/parser/partial.rs#L64-L68

```rust
pub struct Partial<T> {
    value: Option<T>,
    errors: Vec<Error>,
}

impl<T> Partial<T> {
    pub fn map<U, F>(self, f: F) -> Partial<U>
    where
        F: FnOnce(T) -> U
    { ... }

    pub fn flat_map<U, F>(mut self, f: F) -> Partial<U>
    where
        F: FnOnce(T) -> Partial<U>
    { ... }

    pub fn value(&self) -> Option<&T> {
        ...
    }

    pub fn errors(&self) -> &[Error] {
        ...
    }

    pub fn verify(self) -> Result<T, Vec<Error>> {
        ...
    }
}
```

This data structure was complemented with a bunch of custom `nom` combinators,
e.g. `map_partial()`, `expect_terminated()`, and `skip_if_err()`, which would
allow me to compose these fault-tolerant parsers together while accumulating
errors in the `errors` field.

The consumer of this data structure would then choose to either:

1. Assert that they need a valid AST without errors by calling `expr.verify()`,
   transforming the `Partial<T>` into a `Result<T, Vec<Error>>`. This option
   would be useful for traditonal batch compiler authors, as well as for testing
   and debugging.
2. Extract and examine the contents of the `value` and `errors` field
   separately. This is what the language server would do: publish the
   accumulated errors to the user's editor in the form of diagnostics and then
   perform further analysis on the syntax tree contained in `value`.

All the parser combinators would have this function signature instead:

```rust
impl Fn(Input) -> IResult<Input, Partial<Output>, Error>
```

While this approach seemed to work well initially, it spiralled out of control
once the parser grew beyond a certain size. The number of `Partial` specific
combinators grew, the parser logic got hairier, more imperative, and trickier to
debug, and the performance implications of carrying around a heavy stack of
errors from function to function [were astonishingly awful][commit]. It didn't
look and feel that much like PEG anymore.

[commit]: https://github.com/ebkalderon/nix-language-server/commit/4cd939a2917709a527bd1967f4a29bfd9f2767cc

I will admit I learned a lot about a breadth of topics during this time, from
benchmarking functions with [`criterion`] to generating flamegraphs with
[`cargo-flamegraph`], and going to extreme lengths to avoid heap allocations to
make the parser as fast as possible. I used [`nom_locate`] to retain string span
information and be as zero-copy as possible when constructing the syntax tree.
But ultimately, I couldn't fix all the warts and fundamental flaws. I needed a
new approach.

[`criterion`]: https://github.com/bheisler/criterion.rs
[`cargo-flamegraph`]: https://github.com/ferrous-systems/flamegraph
[`nom_locate`]: https://docs.rs/nom_locate

## The paper's solution

Finally, back to the paper that originally inspired this article! I shelved this
project some months ago due to work and personal life matters, but came back
to it last month with some fresh ideas and a better intuition of where to look.
Discouraged by the previous setbacks, I was questioning whether parser
combinators in general were flexible enough to express parsers which were both
permissive and fault-tolerant, while also emitting good hand-crafted
diagnostics. But then I stumbled upon the ["Syntax error recovery in parsing
expression grammars" (2018)][paper] paper while scouring the ACM DL search
engine for interesting articles last night.

The authors of this paper actually managed to get pretty great results parsing
the [Lua programming language] using a set of extended PEGs, producing excellent
tailor-made diagnostics rivaling the automatic error recovering capabilities of
their control, a top-down [LL parser] generated by [ANTLR]. Their techniques are
similar to those outlined in [this excellent blog post by @matklad][post],
prominent author of [`rust-analyzer`] and [`rowan`], a library for lossless
[concrete syntax trees].

And they managed to do all of this while not bailing out on the first parse
error and still producing some kind of syntax tree _100% of the time_ in all the
cases they tested. And the final result still looks and feels like PEG. Quite
promising stuff! :heart_eyes:

[Lua programming language]: https://www.lua.org/
[LL parser]: https://en.wikipedia.org/wiki/LL_parser
[ANTLR]: https://www.antlr.org/
[Modern Parser Generator]: https://matklad.github.io/2018/06/06/modern-parser-generator.html
[post]: https://matklad.github.io/2018/06/06/modern-parser-generator.html
[`rust-analyzer`]: https://github.com/rust-analyzer/rust-analyzer
[`rowan`]: https://github.com/matklad/rowan
[concrete syntax trees]: https://en.wikipedia.org/wiki/Parse_tree

I was immediately excited by this paper since I knew that any error recovery
strategy for PEG could potentially be applicable in a parser combinator library
like `nom`, given that both approaches employ recursive descent. If you're
interested in the specific error recovery strategies used, I would strongly
recommend you read the entire paper for yourself.

I would also recommend looking at [LPegLabel], a reference implementation of a
PEG parser generator using these techniques developed by authors Medeiros and
Mascarenhas, if you'd like a more concrete example.

[LPegLabel]: https://github.com/sqmedeiros/lpeglabel

In general, though, it boils down to a few key principles:

1. Parsing should _never_ fail. If some kind of syntax tree isn't produced, it's
   considered a bug. Basically, the output of the top-level parser should be a
   `(T, Vec<Error>)`, not `Result<T, Vec<Error>>`. Also, your syntax tree should
   provide a fallback `Error` node type for representing invalid, unparseable
   expressions.
2. The PEG rules describing your language are loosened and extended to include
   recovery expressions annotated by "labels" which basically ensures that
   parsing never fails. These recovery expressions emit error messages when
   evaluated but will silently allow parsing to continue unabated. Sometimes
   they skip forward a few tokens, but often the cursor just stays where it is.
   I'll demonstrate a very basic recovery expression with implemented with `nom`
   later on.
3. Synchronization tokens like `)`, `}`, and `;` are used to skip ahead through
   the text when necessary to avoid recovery expressions emitting spurious
   errors down the line after an earlier one has already fired.

The first and third concepts aren't really anything new in the academic space.
Infallible parsing, special syntax tree nodes for marking errors, and the use of
synchronization tokens for error recovery are common tactics used to great
effect in hand-written recursive descent parsers, but this paper applies them
nicely to PEG parsers (which in turn, I would apply to parser combinators)
without sacrificing their declarative nature. It also provides a small library
of handy recovery expressions you can use in different situations to either emit
high quality errors or suppress them.

Let's take a look at a real world example of a fault-tolerant parser written
in Rust using the `nom` 5.0 parser combinator library.

## Demonstration

The full source code for this demo can be found [here][demo] if you'd like to
read the whole thing, but the idea is to apply the most basic error recovery
strategies outlined in the paper for PEGs using parser combinators.

[demo]: https://github.com/ebkalderon/example-fault-tolerant-parser

Below are some Rust types and traits that we will use throughout our example:

```rust
use std::ops::Range;

/// This used in place of `&str` or `&[u8]` in our `nom` parsers.
type LocatedSpan<'a> = nom_locate::LocatedSpan<&'a str, State<'a>>;
/// Convenient type alias for `nom::IResult<I, O>` reduced to `IResult<O>`.
type IResult<'a, T> = nom::IResult<LocatedSpan<'a>, T>;

trait ToRange {
    fn to_range(&self) -> Range<usize>;
}

impl<'a> ToRange for LocatedSpan<'a> {
    fn to_range(&self) -> Range<usize> {
        let start = self.location_offset();
        let end = start + self.fragment().len();
        start..end
    }
}

/// Error containing a text span and an error message to display.
#[derive(Debug)]
struct Error(Range<usize>, String);

/// Carried around in the `LocatedSpan::extra` field in
/// between `nom` parsers.
#[derive(Clone, Debug)]
struct State<'a>(&'a RefCell<Vec<Error>>);

impl<'a> State<'a> {
    /// Pushes an error onto the errors stack from within a `nom`
    /// parser combinator while still allowing parsing to continue.
    pub fn report_error(&self, error: Error) {
        self.0.borrow_mut().push(error);
    }
}
```

Our top-level `parse()` function is defined as follows:

```rust
pub fn parse(source: &str) -> (Expr, Vec<Error>) {
    /// Store our error stack external to our `nom` parser here. It
    /// is wrapped in a `RefCell` so parser functions down the line
    /// can remotely push errors onto it as they run.
    let errors = RefCell::new(Vec::new());
    let input = LocatedSpan::new_extra(source, State(&errors));
    let (_, expr) = all_consuming(source_file)(input).expect("parser cannot fail");
    (expr, errors.into_inner())
}
```

Notice how we `.expect()` on our all-consuming `source_file()` parser. Remember,
if we fail to produce some kind of syntax tree and consume all of the input 100%
of the time, that's considered a bug in the parser.

For the sake of example, I've implemented only one recovery expression outlined
in the paper in the form of a custom parser combinator I call `expect()`. It
looks like this:

```rust
/// Evaluate `parser` and wrap the result in a `Some(_)`. Otherwise,
/// emit the  provided `error_msg` and return a `None` while allowing
/// parsing to continue.
fn expect<'a, F, E, T>(parser: F, error_msg: E) -> impl Fn(LocatedSpan<'a>) -> IResult<Option<T>>
where
    F: Fn(LocatedSpan<'a>) -> IResult<T>,
    E: ToString,
{
    move |input| match parser(input) {
        Ok((remaining, out)) => Ok((remaining, Some(out))),
        Err(nom::Err::Error((input, _))) | Err(nom::Err::Failure((input, _))) => {
            let err = Error(input.to_range(), error_msg.to_string());
            input.extra.report_error(err); // Push error onto stack.
            Ok((input, None)) // Parsing failed, but keep going.
        }
        Err(err) => Err(err),
    }
}
```

This is the realm where parser combinator libraries really shine. This
`expect()` combinator can be composed with other parser functions and produce
results which closely map to their PEG counterparts. Below is an example parser
capable of parsing a parenthesized expression which uses `expect()` to report
errors:

```rust
fn paren(input: LocatedSpan) -> IResult<Expr> {
    // This approach of using `expect()` to annotate a parser
    // with a message follows the original paper's definition of
    // labels annotating certain parts of the PEG grammar.
    let paren = delimited(
        char('('),
        expect(expr, "expected expression after `(`"),
        expect(char(')'), "missing `)`"),
    );

    map(paren, |inner| {
        Expr::Paren(Box::new(inner.unwrap_or(Expr::Error)))
    })(input)
}
```

## Results

The final results of this toy implementation were quite striking, consistently
producing some very pretty parse results. Given a very trivial AST that looks
like this:

```rust
/// `foo`, `foo_bar`, `foo123`
#[derive(Debug)]
struct Ident(String);

#[derive(Debug)]
enum Expr {
    /// `(foo)`
    Paren(Box<Expr>),
    /// `foo`
    Ident(Ident),
    /// An unparseable, invalid expression.
    Error,
}
```

The following outputs were produced by calling `parse()`:

<div class="table-auto">

Input  | Produced syntax tree         | Errors
-------|------------------------------|---------------------------------------------------------------------------------
foo    | `Ident(Ident("foo"))`        | ```[]```
(foo)  | `Paren(Ident(Ident("foo")))` | ```[]```
(foo)) | `Paren(Ident(Ident("foo")))` | ```[Error(5..6, "expected EOF")]```
(%     | `Paren(Error)`               | ```[Error(1..2, "unexpected `%`"), Error(2..2, "missing `)`")]```
(      | `Paren(Error)`               | ```[Error(1..1, "expected expression after `(`"), Error(1..1, "missing `)`")]```
%      | `Error`                      | ```[Error(0..1, "unexpected `%`")]```
()     | `Paren(Error)`               | ```[Error(1..2, "expected expression after `(`")]```
&nbsp; | `Error`                      | ```[]```

</div>

These results are markedly better than what I had gotten with `nom` previously
when I was relying on the built-in [custom error management] facilities, and the
logic is significantly more declarative and understandable than the `Partial<T>`
approach. And best of all, the final parsers are much shorter, easier to reason
about, and are more directly analogous to their PEG equivalents, which makes the
project much more maintainable in the long run.

[custom error management]: https://github.com/Geal/nom/blob/master/doc/error_management.md

## Future work

The example shown above was intentionally designed very simply in order to
demonstrate the core concepts from Medeiros' and Mascarenhas' 2018 paper applied
to parser combinators with `nom`. In order to support parsing a complex
programming language like Nix, I will need to translate more of the recovery
expressions described in the paper to `nom` combinators. I will also need to
investigate richer forms of error representation, possibly containing multiple
spans, warnings, lints, etc.

I should also add that the parser used in my actual project does not use
`LocatedSpan`, but instead processes a custom `Tokens<'a>` type. Because of
this, I can't integrate the code used in this example into my project as-is. I
will need to adapt it to work with this custom type, a topic which is considered
out of scope for this particular post.

I also didn't cover incremental parsing nor concrete syntax trees (that much) in
this guide, and I plan for `nix-parser` to produce a lossless concrete syntax
tree (courtesy of [`rowan`]) instead of an abstract syntax tree like the
example.

[`rowan`]: https://docs.rs/rowan

## Conclusion

Implementing a parser with good error recovery strategies and rich,
user-friendly diagnostics is as much an art as it is a science (I think the Rust
compiler devs would agree). This is even more true when it comes to parsers
catering to the needs of language servers, REPLs, and other interactive uses
where you need to be very tolerant to parse errors and provide meaningful
diagnostics in response to messy and incomplete input. I learned many valuable
things on this journey, and I'm still learning further as I go along. For one, I
need to brush up on my formal methods and re-read the paper a few more times to
fully digest the information.

I'm incredibly grateful to the [ACM](https://www.acm.org/) for having made their
Digital Library open to the public during this global pandemic, and I'm also
grateful to Sérgio Medeiros (UFRN, Brazil) and Fabio Mascarenhas (UFRJ, Brazil)
for having produced the original research paper. I'm glad to have stumbled
across it, and I learned some nice lessons out of it. If you're a fan of PEG
parsers and/or parser combinators and you haven't read this paper yet, please
do. It's pretty neat!

In the meantime, I'll be casually hacking away on [`nix-language-server`][nls]
whenever I have some spare time, armed with plenty of useful knowledge and
principles I didn't have before. Maybe I'll actually get to producing meaningful
auto-completions and semantic analysis out of it for once, as soon as I can
focus on traversing the syntax tree itself and building a usable interpreter for
evaluating the language. :stuck_out_tongue:

## External links

* ["Syntax error recovery in parsing expression grammars"][paper]
* [Source code for demo][demo]
* [Modern Parser Generator] \([@matklad])
* [Roslyn Overview (.NET)]
* [ebkalderon/nix-language-server][nls]

[Modern Parser Generator]: https://matklad.github.io/2018/06/06/modern-parser-generator.html
[@matklad]: https://github.com/matklad
[Roslyn Overview (.NET)]: https://github.com/dotnet/roslyn/wiki/Roslyn-Overview#errors
