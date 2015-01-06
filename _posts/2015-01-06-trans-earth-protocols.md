---
title: "Trans-earth networking protocols"
tagline: "Will your credit card work on Mars?"
tags: ["networking", "internet", "future"]
---

Assuming you read scifi novels — have you ever stopped, really stopped
and thought about how the technology in those stories work? Let's skip
the obvious things that you just have to suspend your belief over like
ray guns, fast-than-light travel, space lifts and sentient artificial
intelligences.

What I'm talking about is the small stuff. Everyday stuff. Like the
Internet and paying for a late-night space-age kebab meal.

<figure> <a
href="/assets/posts/PIA17944-MarsCuriosityRover-AfterCrossingDingoGapSanddune-20140209.jpg"><img
src="/assets/posts/PIA17944-MarsCuriosityRover-AfterCrossingDingoGapSanddune-20140209.jpg"
alt="Mars surface view"></a>

<figcaption>That'll be your tracks from the pub crawl. (Source: <a href="http://commons.wikimedia.org/wiki/File:PIA17944-MarsCuriosityRover-AfterCrossingDingoGapSanddune-20140209.jpg">Wikimedia Commons</a>)</figcaption>

</figure>

## Pub Crawl at Valles Marineris

So you take the trans-planet express line from Earth to Mars and after
a long and thorough pub crawl with your local green-skinned friends
you feel peckish, and order *the space-age Buck Lightyear premium
kebab*. You whip out your earthen debit card, chuck it to the reader,
enter your pin and

    wait

    wait

    wait

    wait some more,

    and a lot more

    for a total of 40 stomach-grumbling long minutes.

At least this would happen **if current EMV protocols are used in the
space-age future**.

Why? The speed of light is finite. Your chip debit card will talk with
the card issuer's backend systems over the network <small>(actually,
it's the terminal that does the talking, and that doesn't talk
directly to the issuer but to a ... well, that's just details)</small>
so that the kebab vendor will get a confirmation they've been reserved
the cost of the meal by the issuer, and the customer's bank balance
(or credit) is valid.

This information needs to travel back and forth between your Earthen
card issuer and the Martian card terminal. Distance between Earth and
Mars varies between 3 and 20 minutes depending on their relative
orbital positions so just one round-trip — request and response — will
take 6 minutes in the best case and over 40 minutes in the worst case.

> In case you're thinking BitCoins … they won't work
> either. Transactions are asynchronous, yes, but you'd still need to
> send one over the high-latency link, wait for the transaction to
> complete, and of course wait for the new transaction block to be
> sent to you. «grumble grumble» says your stomach.

This pretty much means that **any kind of online protocol is not going
to work in space**, except if both endpoints are really close (Earth
to Moon, Mars to Phobos and Deimos).

**Even if you are patient** and willing to wait for hours for a
transaction to clear, most today's network services have timeouts
(connection timeouts, nonce validity timeouts etc.) that will prevent
whatever you are trying to do from completing if endpoints are
separated by distances of light minutes.

> Is it going to be IPv6? For what I know there are no limitations in
> the IPv6 *itself* that prevent Earth-Mars Internet from working. TCP
> has a fixed maximum segment lifetime of 2 minutes, but this is
> easily circumvented with packet reassembly at trans-planet
> gateways. More critical are applications and protocols that set
> limits within themselves. Of course many IP-based protocols are very
> chatty and synchronous, neither being good for very long latency
> links.

This would also mean you can't post those boozing pictures on Twitter,
either.

## The card should clear immediately!

And so it will. But the clearing protocol **will not be based on the
current model**. Your card issuer has probably pre-reserved a portion
of your balance or credit and "transferred" it over to a local Martian
operator, and this local balance would be balanced between Earth and
Mars "behind the scenes", asynchronously.

Twitter, Google? Probably <tt>twitter.com</tt> and <tt>google.com</tt>
map to <strike>geo-located</strike> planet-located IP addresses and
these services are set up to do long-haul asynchronous synchronization
on their (relevant) data sets between Earth and Mars.

There are other ways, of course. These are just examples to show that
it is possible to at least generate an illusion of network service
ubiquity even over planetary distances.

So, doable.

But not directly.

## But it's the far future, why worry now?

When **eventually** we've transitioned from
[IPv4 to IPv6](http://en.wikipedia.org/wiki/IPv6_deployment) do you
really think it will be **EVER UPGRADED AGAIN**?

Absolutely no. No, no no and no.

This is one prediction I'll put down.

**IPv6 will not be replaced within my lifetime.**

It will be extended and expanded with new options and potentially
other minor backwards-compatible (as with IPv4) changes, but
fundamentally, current-day IPv6 will be **the internet protocol** even
when we're building outposts and colonies on the Moon and on Mars.

My point is that some portion of internet protocol choices made
**today** are going to be around much, much later. IPv4 is 35 years
old now, and not going anywhere in a hurry. IPv6 in 2100? Highly
probable.

## Challenge of the future

Internet use has gone through several phases, each with different
assumptions, starting from early constantly connected and centrally
operated (wired networks only, most users had only one or few
"connection points") to current intermittently connected model
(assumptions of multiple location-fluid devices with variable
connectivity).

All previous and current models have an implicit assumption of **a
small latency** of less than a few seconds. There may be sometimes
congestion leading to temporary latency increases, but more or less
we've lived under the knowledge that a network packet can traverse to
the farthest end of our planet within a fraction of a second. It will
— it's a fact of physics.

In *a potential* future with spread of human populations to different
moons and planets this latency assumption will work only
**locally**. That's a world where service designers have to tackle yet
another problem: **how to provide good service when network latencies
are minutes or hours**.

Though, this is not a problem that should keep anyone awake at night.

## Back to the kebab

I referred to scifi books and our hidden assumptions of the world. A
good scifi writer will not get bogged down by thinking how today's
technology would **not** work in the future. Good story it makes not.

Technology and its improvement doesn't work like that way. We can't
ignore laws of physics for the sake of a good story. Similarly there
is a human imperative (scientific, commercial or out of curiosity) to
make these things work.

I'll be waiting for the first Twitter post from Mars base.
