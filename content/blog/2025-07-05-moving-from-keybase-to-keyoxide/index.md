+++
title = "Moving from Keybase to Keyoxide"
description = "Mourning the slow death of Keybase and introducing Keyoxide, an open source decentralized replacement."
date = 2025-07-05T03:08:11-04:00

[taxonomies]
tags = ["cryptography", "keybase", "keyoxide", "openpgp", "indieweb"]
categories = ["meta"]

[extra]
copy_button = true
stylesheets = ["css/comments.css"]

[extra.social_media_image]
path = "keyoxide-profile-page.png"
alt_text = "Screenshot of my personal Keyoxide profile page with a few identity proofs visible"
+++

Ever since [the acquisition of Keybase by
Zoom](https://keybase.io/blog/keybase-joins-zoom) while the world was in the
throes of the COVID-19 pandemic, the pace of Keybase's development essentially
stopped.

{{ responsive_image(src="contributors-graph-for-keybase-client.png",
   alt="A screenshot of the Contributors graph for the `keybase/client` GitHub repository indicating a sharp decline in activity to almost nothing since May 2020") }}

The official blog went completely silent, third-party integrations started to
break down, previously-announced improvements to Keybase never materialized,
unaddressed GitHub issues began piling up, and I started encountering an
increasing number of 404 errors while navigating through the official site.

{% alert(type="info") %}
For those unaware, [Keybase](https://keybase.io/) is (was?) a cutting-edge
social network which aimed to make <abbr title="Pretty Good Privacy">PGP</abbr>
approachable, convenient, and _fun_. By creating and uploading an
[OpenPGP](https://www.openpgp.org/) public key to Keybase, you could:

* Prove ownership of your online identities on Twitter, Reddit, GitHub, etc. or
  even entire websites and Bitcoin wallets, like a "digital passport" of sorts.
* Privately message other users via [end-to-end
  encrypted](https://en.wikipedia.org/wiki/End-to-end_encryption) chat rooms.
* Back up personal files to an encrypted cloud drive akin to Google Drive.
* Follow other Keybase users and be notified when their "link tree" of online
  identities has changed.
* Among other things...
{% end %}

As service quality continued to degrade, social media networks began removing
Keybase integration from their products, which makes Keybase far less useful as
a so-called "digital passport" these days. For instance, [Mastodon removed
their integration back in November 2021](https://github.com/mastodon/mastodon/pull/17045).

Thankfully, there [already][kleopatra] [exist][signal] [alternatives][proton]
for basically all of Keybase's functionality _except_ the core identity
verification part, for which I have been actively seeking a replacement.

[kleopatra]: https://www.openpgp.org/software/kleopatra/
[signal]: https://signal.org/
[proton]: https://proton.me/drive

## Enter Keyoxide

Which brings us to this year! I recently stumbled upon
[Keyoxide](https://keyoxide.org/) as a possible replacement for Keybase. While
it's not perfect, it checks all the main boxes:

- [x] Profiles consist of a name, avatar, and OpenPGP key fingerprint.
- [x] Verifies many online social media services, e.g. Mastodon, Reddit,
      Bluesky, and others ([with more on the way]).
- [x] Verifies domain name ownership [via DNS `TXT` records].
- [x] [Truly decentralized], unlike Keybase.[^1]

[^1]: When I say "decentralized" here, I do _not_ mean blockchain! Instead,
      think email, RSS feeds, or the World Wide Web itself.

[with more on the way]: https://codeberg.org/keyoxide/doipjs/issues/?q=&type=all&state=open&labels=183437
[Truly decentralized]: https://blog.keyoxide.org/keyoxide-launch/#What_are_those_decentralized_identity_proofs_you_keep_mentioning?
[via DNS `TXT` records]: https://docs.keyoxide.org/service-providers/dns/

Incidentally, the folks developing Keyoxide are the same folks behind the
[Ariadne Identity Specification](https://ariadne.id/). Ariadne is the open
protocol which underpins Keyoxide and is responsible for the actual
"decentralized identity verification" stuff.

The best thing about Keyoxide/Ariadne, in my opinion, is that **the identity
proofs are embedded directly in your public key.** This means your Ariadne
identity profile truly belongs to you and isn't dependent on a centralized
service somewhere remaining functional (_ahem_... looking at you, Keybase).
Heck, if you're feeling determined enough and have plenty of time to spare, you
could even verify the identity claims _by hand_. I definitely don't recommend
it, though; that sounds pretty damn tedious. :stuck_out_tongue:

And because Ariadne is an open specification that builds on existing
technologies like OpenPGP and [ASP], rather than a monolithic product, your
cryptographic proofs will feasibly outlive the Keyoxide project itself, should
the developers ever stop working on it someday.

Though I don't expect that day to come anytime soon... The Keyoxide project is
funded primarily via generous [grants by the NLnet foundation] along with
[private donations on OpenCollective]. Being a non-profit organization with
relatively stable financial backing and not needing to host any user data
themselves, they should have a fighting chance of operating for a long time.

[ASP]: https://ariadne.id/related/ariadne-signature-profile-0/
[grants by the NLnet Foundation]: https://nlnet.nl/project/Keyoxide/
[private donations on OpenCollective]: https://opencollective.com/keyoxide

By contrast, it's clear (in retrospect) that Keybase's for-profit business model
was never going to be sustainable long-term. The Keybase team was desperately
looking for ways to monetize their service: after only 4 years of existence,
they [took funds from the Stellar Development Foundation] as a way to stay
afloat. Shortly thereafter, the app rolled out multiple cryptocurrency-focused
features such as [crypto "coin flipping"] and [built-in Stellar crypto wallets]
with surprise airdrops of coins to Keybase users' wallets. It seems even this
still couldn't stem the bleeding, though, hence the eventual Zoom acqui-hire in
2020.

[took funds from the Stellar Development Foundation]: https://keybase.io/blog/keybase-stellar
[crypto "coin flipping"]: https://keybase.io/blog/cryptographic-coin-flipping
[built-in Stellar crypto wallets]: https://keybase.io/blog/keybase-stellar-launch

### Getting Started

To get started with Keyoxide, I simply opened my browser and navigated to
[https://keyoxide.org/d5ad5bd47835b0f0b0c3046c00ab4c0942dcba25][my-profile]
(which is the OpenPGP fingerprint of my public key). To my delight, a profile
page already existed for me! :tada:

[my-profile]: https://keyoxide.org/d5ad5bd47835b0f0b0c3046c00ab4c0942dcba25

{{ responsive_image(src="keyoxide-profile-page.png",
   alt="A screenshot of my profile page on Keyoxide displaying a (somewhat dated) photo of me",
   caption="My Keyoxide profile, after adding a few proofs") }}

It seems that Keyoxide automatically creates user profiles for all public keys
present on the most popular PGP keyservers out there, including
[keys.openpgp.org](https://keys.openpgp.org/), which I think is pretty neat.
Furthermore, Keyoxide automatically retrieved a user avatar from
[Gravatar](https://gravatar.com/) based on the email address associated with my
own PGP key, which was a nice touch. Granted, it's a fairly dated photo, but
that issue should be trivial enough to fix.

### Adding Identity Proofs

Adding new identity proofs to my Keyoxide profile is nowhere near as streamlined
than it is with Keybase, but it wasn't too bad once I got the hang of it. Here's
the gist:

1. Find the online service or social media network you would like to verify in
   [the Keyoxide documentation](https://docs.keyoxide.org/service-providers/).

2. Create the proof according to the given instructions. For example, [here's a
   link to my GitHub proof][github-proof].

3. Record the proof in your OpenPGP key using the appropriate _notation_ per the
   Ariadne spec. This process only requires [GnuPG](https://gnupg.org/) and an
   open terminal window.

   1. ```bash
      gpg --edit-key d5ad5bd47835b0f0b0c3046c00ab4c0942dcba25
      ```

   2. At the `gpg>` prompt, type `notation` and hit <kbd>Enter</kbd>. This will
      ask you to enter a string of the form:

      ```
      proof@ariadne.id=$THE_PROOF
      ```

      Usually, `$THE_PROOF` refers to a URL to the social media profile you're
      trying to claim, but might contain other information. Refer to the
      official Keyoxide instructions for that specific online service to see the
      exact format.

   3. At the `gpg>` prompt, type `save` and hit <kbd>Enter</kbd>. This will
      apply all changes to your public key and quit out of GnuPG.

4. Upload your updated public key to the OpenPGP keyserver of your choice. In my
   case, that keyserver is [keys.openpgp.org](https://keys.openpgp.org/). This
   can be done quickly without leaving the terminal window:
   ```bash
   gpg --export d5ad5bd47835b0f0b0c3046c00ab4c0942dcba25 | curl -T - https://keys.openpgp.org
   ```
   If successful, the command prints the following output:
   ```
   Key successfully uploaded. Proceed with verification here:
   https://keys.openpgp.org/upload/R_9QF8lSV9hGQJDLgS6igAwfzwToUySZ6IMuVICteuEDQ5k40gMCS7Jd7ckh5iO7WlWK2LHyuV5WX2GtyTWYcq5CLYBAAiZd-rMC9-Eln87cuOS6MMaimomGnur1hqYcB3-K2AMmSeGOcje78vSgRLvF6ZmDiZKuKtmEbcD8CupY3UipnExg1lTEY0nTx2qRf3ppdX_yrG7HsJn2kyMGquLXTw
   ```
   You must open this one-time link in your browser before it expires for your
   updated PGP key to be available worldwide.

[github-proof]: https://gist.github.com/ebkalderon/b2ae0515fcb6933cff7880b68d4d14fe

That's pretty much it! Once you refresh your browser, your Keyoxide
profile page should automatically show the new identity proofs with either a
green checkmark (indicating successful identity verification) or a red "x"
(indicating failure) next to each one.

## Conclusion

So yeah... Keyoxide is pretty neat! I'm happy to have an open source alternative
to Keybase, and I'm especially happy to have my online identity double-verified
between Keyoxide and Mastodon. :smile:

{{ responsive_image(src="double-verified-mastodon.png",
   alt=`A screenshot of my Mastodon account profile, where the link to Keyoxide is highlighted with a green checkmark, indicating successful reverse verification between the two sites`,
   caption="Mastodon and Keyoxide verifying each other... Verification-ception!") }}

[My Keyoxide profile][my-profile] is linked in the footer of this website
alongside my other social media accounts. While [my Keybase
account](https://keybase.io/ebkalderon) will remain active for the time being, I
will no longer be actively using it.
