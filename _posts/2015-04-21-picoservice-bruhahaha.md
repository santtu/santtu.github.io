---
title: "Picoservice bruhahaha"
tagline: "Sir, I think you have consumed too many microservices for today and should head for home."
tags: ["µ²services", "microservices"]
---

I've been busy, as again, an haven't had a good chance to continue on
my [µ²services](/tags.html#µ²services-ref) series. I'm planning to
discuss more of the potential implications of technology development
meeting microservice architecture models. But this post isn't about
that.

Instead I want to comment a bit on the nano/picoservice commentary
found over the net. For example:

<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<!-- <blockquote class="twitter-tweet" lang="en"><p>Picoservices. Like &quot;hello, world&quot;.</p>&mdash; MY Camelopardalis (@pavlobaron) <a href="https://twitter.com/pavlobaron/status/567393808690581506">February 16, 2015</a> -->
<!-- </blockquote> -->

<blockquote class="twitter-tweet tw-align-center" lang="en"><p><a href="https://twitter.com/michaelneale">@michaelneale</a> I thought we agreed that was the hip new marketing term for functions?</p>&mdash; Mark Wotton (@mwotton) <a href="https://twitter.com/mwotton/status/562424720490901504">February 3, 2015</a>
</blockquote>

<!-- <blockquote class="twitter-tweet" lang="en"><p>So we&#39;ve got services and microservices. Can we get a nanoservice? picoservice? femtoservice?</p>&mdash; Snark As a Service (@petrillic) <a href="https://twitter.com/petrillic/status/574972031470432256">March 9, 2015</a> -->
<!-- </blockquote> -->

<!-- <blockquote class="twitter-tweet" lang="en"><p>&quot;MICROSERVICES ARE TOO MONOLITHIC. LEVERAGE OUR NANOSERVICE FOR MOST IMPORTANT COMMUNICATIONS IN ROBUST CLOUD.&quot; <a href="http://t.co/7hLpkq3FMY">http://t.co/7hLpkq3FMY</a></p>&mdash; Taylor Edmiston (@kicksopenminds) <a href="https://twitter.com/kicksopenminds/status/573552541394403329">March 5, 2015</a> -->
<!-- </blockquote> -->

**I absolutely love these comments!!** I absolutely think that at
least 95% of use of "microservice" is just hot air. However if you
take "microsizing" as an end goal itself and extrapolate to smaller
and smaller scales you get nanoservices and picoservices on an
function and instruction level granularity:

<blockquote class="twitter-tweet tw-align-center" lang="en"><p>1k smaller microservice is nanoservice; exposes assembly instructions via HTTP+JSON; pikoservices become inadressable due to quantum effects</p>&mdash; Tomas Petricek (@tomaspetricek) <a href="https://twitter.com/tomaspetricek/status/540159905236520960">December 3, 2014</a>
</blockquote>

Tomas of course is making a point of this absurdity.

What I think what microservices (and by extension, nano and pico too)
are: **Microservices are externally loosely coupled but internally
tightly coupled functional service components**.

Although it is not evident from this definition, most value from
microservice architecture actually comes from **organizational
improvement** by making the underlying loose-tight coupling **explicit
in development, management and operations**. This also means that the
true potential value of a microservice architecture is difficult to
determine as it is more dependent on the development organization
itself than in the actual software they are developing.

In the end you must ask yourself

<div style="text-align: center; padding: 1em; line-height: 1.2em; font-size: x-large;">
Do microservices make **snarzzz** more <span style="white-space: nowrap;">**flordbious**?[^2]</span>
</div>

**It just depends.** Depends on you, your team, your resources, your
processes, your choice of technology, everything. Investigate and
decide yourself. Don't be a slave to
[backward causality](http://www.slideshare.net/swardley/playing-chess-with-companies/15).

So to clarify for my imaginary pundit what **I** mean and don't mean
when talking about micro- or µ²services:

* Replacing function calls with "services" is just
  **idiotic**. Plainly and simply idiotic and anyone who claims anything
  remotely similar is a plain walking and talking bullshit machine.

  This same thought experiment was done in reality with remote
  procedure calls (RPC) already a decade ago and the result is **local
  and remote operations are fundamentally different**. You can not
  create a distributed system based on "function invocation" pattern.

  A call to a library routine should now and in the future be a local
  function call[^1].

* I use or at least used to use the term µ²services to emphasise that
  the trend of shrinking containers may have (some unforeseen)
  consequences on how we develop and use microservices.

  Perhaps I should just stop using that term instead.

Anyway, check out some of these cool posts and sites:
[A VM for every URL](http://www.skjegstad.com/blog/2015/03/25/mirageos-vm-per-url-experiment/)
by Magnus Skjegstad,
[Microservice Classification Model Proposal](https://taidevcouk.wordpress.com/2015/02/08/microservice-maturityclassification-model-proposal-first-draft/)
by Daniel Bryant and of course, the
[ALL CAPS AS A SERVICE](http://shoutcloud.io/).

P.S. All of the tweets above were written clearly with tongue in
cheek. Yet, the fact that people are feeling the need to dismiss
"picoservices" for me is a sign that the idea of shrinking services as
a goal itself is floating around — and since I've been writing about
[µ²services](/tags.html#µ²services-ref) I want to make it clear that
*that particular* model of sub-microservices is not what I am talking
about.

----

[^1]: With no significant external constraints or requirements applying. This is not science, this is engineering. You can always find counter-examples but they do not a general case make.

[^2]: Substitute your own corporate, process or agile buzzwords.
