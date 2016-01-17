---
title: "On Software Development and Layperson's Perceptions"
tagline: "Easy Peasy or Fiendishly Hard?"
tags: ["software development", "software estimation", "psychology", "sociology"]
---

Since I have been in the "software business" for about two decades it
is natural that I project my own knowledge on to any software problem
I hear. Yet sometimes I get a glimpse of how this whole "software
thing" might look to people who have little or no knowledge at all of
software development.

When I recently was complaining about a billing service (of a local
sporting association) lacking a very useful and common feature, the
reply I got gave me one of these "oh, so that's what it looks like"
moments of insight. **"The vendor asked too much money for the
feature."**

A few thoughts raced my mind.

* *It just can't be **that** expensive - this must be a case of
  sticker shock!*
* The system does feel a little home-brewed, maybe it is a bespoke or
  tailored solution instead of COTS or SaaS?
* In that case *the vendor may be trying to cover development costs of
  a new feature, plus some.*
* Then again *the feature is pretty basic and could probably
  be implemented in one day, with time to spare.*

But thinking this way is just looking at trees instead of the forest.

It's not about *my* views or *my* estimates. I am not the customer of
the vendor. I do not make a decision here. This is a case of
information asymmetry between the vendor and their customer. My
viewpoint is more symmetric, and thus not valid in this case.

What is the problem, then?

Before going to the main question I have (about the forest), let me
first take a look at some trees first.

## Estimation is useless! Estimation is valuable!

While software estimation[^estimation] itself has been
[studied for a long time](https://scholar.google.fi/scholar?q=%22software+estimation%22&hl=en&as_sdt=0%2C5&as_ylo=&as_yhi=1980),
is it even possible to estimate software development efforts in
reality? What is its place in the world of agile and lean development?

I've seen people think that agile development has made away with
software estimation. **It has not.** Task sizing, planning poker or
even just "guessimating" whether a story will fit a sprint or not *are
all judgments based on software estimation*. Doing estimation by the
seat of the pants instead of formally does not make it go away.

Software estimation is also known to go horrendously wrong. I am not
going to even link examples, it's that depressing. [...] So which is
it?

* Estimating "small" problems can be done with *useful reliability and
  accuracy.*[^useful]
* Estimating "large" problems is difficult because *requirements are
  not known to sufficient detail*.[^requirements]

My view is that software estimation in itself is not useless and when
used in correct context can yield usefully accurate results.

<small>Just think about it yourself — a programmer is making
judgments about task complexity and difficulty all the time. If these
estimates were completely useless what would that mean? I mean, if
you'd estimate a ten-minute task to take five years? *You would be
bloody useless.* And jobless, fast.</small>

## Software is easy! Software is hard!

I've written [previously]({% post_url 2013-10-28-life-is-easier %})
about the power of being able to write programs. But is software easy?
Being able to use programs for automating rote tasks just means that
it is incredibly *powerful*.

Software is not easy or hard. There are hard limits to some problems
that come from either the theory of computability or from physical
limits, but software in itself is not easy or hard. *Learning how to
write software* may be hard, or it may be easy, but this is as
meaningless as saying that learning to draw is easy or hard — some
people may have natural affinity, or the drive to learn. If so,
learning is *apparently* easy.

Most of the things we value are difficult and time-consuming to
learn. Even if some people make learning look easy.

Learning to do software is hard. So is learning to play violin.

**Yet** — yet I have often encountered, and I believe to be common
that many people think software is easy. "Easy" in the sense that "it
cannot take more than a few days" easy. "Easy" in the meaning that
"those people at WhizzyCorp got 1M users in two weeks" easy. "Easy" in
the suggestion "I can get a random programmer to replace your easy
job" easy. Banal, if you may.

Some things that look like magic are actually easy to do in software —
now. Some things that are difficult today are easy — in the
future. This rapid change may confuse people both ways, both into
thinking that something is not possible when it actually has become
possible due to a recent development, but also equally well into
tricking people thinking that past rapid changes automatically
translate into *automatically* making previously difficult things easy
*now*.

## Finally, the forest.

I think that there is a gulf between "laypeople" and "professionals"
regarding the difficulty and complexity of software development. This
is a point I find difficult to explain even to myself — this train of
thought is work in progress. I'll try my best to articulate this
viewpoint in text now.

First, this gulf is not about skills or knowledge. I have absolutely
no idea on how to construct an airplane or how much of work it
does. Yet someone does.

Someone out there does not have any idea on how much work is to create
software for a Mars rover. Well, *I don't*, but someone at NASA does.

Unfortunately software development is often bespoke or tailored
work. This means there is information asymmetry between customer and
vendor. *Even when assuming honest and ethical vendors* this asymmetry
persists.[^dishonest]

So when a software professional gives an estimate — making the
assumption that it is a **reasonably accurate estimate given the
constraints I outlined above** — what is a layperson e.g. the customer
to do with this estimate? There are four possibilities (SWOT anyone?)
between professional's estimate and customer's expectations:

1. Both match and are correct: nice
2. Estimate is correct and expectations are incorrect: customer is
   happily surprised (estimate is lower) or ... put into a bind
   (estimate is higher)
3. Estimate is incorrect and expectations are correct: oh woe is me[^woe]
4. Both are incorrect: run, don't look back, just run

<figure>
<a href="/assets/posts/vendor-estimates-vs-customer-expectations.svg"><img
src="/assets/posts/vendor-estimates-vs-customer-expectations.svg" alt="Customer expectations vs vendor estimates"></a>

</figure>


Finally, the question:

<p class="shout">
Why and how do layperson expectations and
professional estimates differ?
</p>

That's it. That's the forest.

*It's not that professionals' estimates are incorrect.* If estimates
are used in a valid context then they are likely to be reliable and
useful.[^fucknot]

*It's not that laypeople's estimates are incorrect*, either. They most
likely are incorrect for the exactly same reasons that any random
person's estimates for Mars rover software or airplane construction
work are incorrect. Vendor estimates and customer expectations are
very likely to differ. Assuming they would match is not a sensible
default.

<p class="shout">
How?
</p>

How they are going to differ? My own experience is that they are more
likely to be underestimates than overestimates. Yet I don't consider
the *quantitative* difference as important as the qualitative:

<p class="shout">
Why?
</p>

Why? I don't know. I tried looking into research into software
estimation.[^notgood] I found papers on estimation techniques, their
validity and accuracy, comparisons between them and so on, but I did
not find anything that would consider the psychological or
sociological reasons why people (especially professionals and
non-professionals) would or could take different viewpoints or stands
on software complexity or effort estimation.

I have no answers here, only questions.

I think that looking into the *why* could potentially help a lot in
the software industry's interaction with customers. I think that the
software industry or academia is not looking enough (if at all) into
the human side — sociology and psychology — of interactions between
*humans* in software professions and *humans* in other professions.

Why are customer requirements misunderstood? What are the warning
signs in human communication or behavior?

Why customers think they have clear requirements when they are not
clear? What is an effective way to communicate the inadequacy of
requirements?

And so on. Consider research into group-think, for example (Bay of Pigs
decision-making is a famous example). This is not computer science, not
computing science, not software engineering. It is cross-department
stuff. Not very popular in CS, I know[^refs].

## The Big Conclusion

<br/>
<br/>
<br/>
<br/>

Nope, there is none.

I wrote this blog post because I got a rare glimpse into
non-software-person thinking, got thinking, and found out questions I
found no answers for.

<br/>
<br/>
<br/>
<br/>

----

[^useful]: Meaning useful in the context of software development project. It is not uncommon to go 3x or 10x way off in estimation of tasks in a scrum sprint, for example. However agile methods have feedback processes meant to keep this deviation from ballooning uncontrollably. In this context estimations do provide metrics useful to guide development projects.
[^requirements]: This is the crux of agile methods. While a waterfall software project could *theoretically* be estimated accurately *given that requirements are known in advance*, in practice nobody knows the requirements in advance (even when they think they do). Agile methods start with the assumption that requirements *will* change.
[^dishonest]: Dishonest and unethical vendors may use the asymmetry to *their own advantage*. Yet information asymmetry can cause problems even for honest and ethical vendors and their customers.
[^woe]: If the vendor estimate is higher, then they will not get the job and it's their loss. If vendor's estimate is lower, they will get the job but there will be hell later when the either the customer ends up paying more than they expect, or the vendor will go negative profit on the project.
[^fucknot]: Likely, likely, likely. Never 100%.
[^refs]: If you got here, please read [this](http://dx.doi.org/10.1109/MC.2002.999774).
[^notgood]: I have to admit I did not do a thorough literary search. Just random searches on scholar, ieexplore, university library search portal and the like.
[^estimation]: For an all-around view on software estimation in practice I can recommend Steve McConnell's book [Software Estimation: Demystifying the Black Art](http://www.stevemcconnell.com/est.htm).
