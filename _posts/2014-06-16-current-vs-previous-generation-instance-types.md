---
layout: post
title: "\"Previous generation instance types\""
tagline: "Where did m1.medium go?"
tags: ["aws", "ec2"]
---

Just recently I noticed that AWS had **removed _most_ first-generation
instance types** from its
[instance type description page](http://aws.amazon.com/ec2/instance-types/). Digging
back in history you can find
[Jeff Barr's post](http://aws.amazon.com/blogs/aws/ec2-update-previous-generation-instances/)
from April 15th describing this change (you can double-check using the
Internet Archive that it
[occurred after April 13th](https://web.archive.org/web/20140413180708/http://aws.amazon.com/ec2/instance-types/)). <small>(How
did I miss that for two whole months?)</small> I started then thinking
about how this relates to my [earlier thoughts]({%post_url 2014-01-13-aws-retiring-instance-types%}) on AWS instance type
retirement.

I drew a doodle as a help to thinking about various known and apparent
things and their relations to underlying realities. I've reproduced it
below. Why? Because I know a picture in the beginning of a blog post
will keep readers engaged a bit more. <small>Did you even read the
previous sentence? I bet half of you skipped the second sentence and
decided to go straight to the picture.</small> Which is a bit of a
mess and isn't terribly coherent even after I've tried explaining it
later.

<figure> <a
href="/assets/posts/aws-previous-generation-graph.svg"><img
src="/assets/posts/aws-previous-generation-graph.svg" alt="thoughts on
aws previous generation instances"></a>
</figure>

First of all note that the change at this time was *purely cosmetic*
as **AWS did not deprecate any instance types**. If you are looking
for m1.medium please check the
[*"previous generation instances"*](http://aws.amazon.com/ec2/previous-generation/)
page.

Let's start with a few quick facts and observations (top part of the
graph):

* No instance types were deprecated
* No more explicit numerical generation numbers, only relative
  ("current" and "previous" vs. "second generation" as in
  [m3 class announcement](https://aws.amazon.com/about-aws/whats-new/2012/10/31/announcing-amazon-ec2-m3-instances-and-m1-price-drop/))
* Current generation instance types conform to Intel's "Powered by
  Intel Cloud Technology" program (all but three)
* **m1.small** is listed as a current generation instance (but
  otherwise gets minimal screen space)
* *"[AWS has] no current plans to deprecate any of the
  [previous generation] instances"* ([source](http://aws.amazon.com/blogs/aws/ec2-update-previous-generation-instances/))
* Pricing strongly favors customers picking current generation
  instance types — AWS's own communication is also very direct in
  pushing customers to use newer instance types

A couple of deeper thoughts then:

**No numeric instance generations.** When "second generation"
instances were originally introduced it made sense to market them as
newer, better and superior to "first generation" instances. Yet the
whole concept of distinct "hardware generations" did not make much of
a sense even then. What are main customer-visible differentiating
features between these? What would a third generation instance be
like? Fourth?

For a customer what matters are capabilities. For instance types these
have always been an unorthonogal bunch and will remain so, which
numerical generations does not clarify even one bit. They are
superfluous.

Good riddance, I say.

**m1.small still holding on.** The on-demand prices from lowest
upwards are: $0.020 for t1.micro, $0.044 for m1.small and $0.070 for
m3.medium.

It might make sense to introduce m3.small to replace m1.small in the
gap between smallest (t1.micro) and the lowest-powered modern instance
(m3.medium). But this can't be done. Why? Part of the reason is that
m1.small is an accident of history and is very difficult to replace.

AWS has three classes of CPU scheduling (year introduced in
parenthesis):

* Fixed (2006). m1.small CPUs are 50% shared between other m1.small
  instances. An eight-core machine can host 16 m1.small instances
  running each having one virtual CPU at about 50% of full Xeon core
  performance.
* Dedicated (2007). Each virtual core is assigned to one physical
  core. This was introduced with
  [m1.large and m1.xlarge](http://aws.amazon.com/about-aws/whats-new/2007/10/22/amazon-ec2-now-in-unlimited-beta-and-launching-new-instance-types/)
  and is used for all but two instance types.
* Variable (2010). t1.micro is the only example of this type of CPU
  scheduling. Instances share CPUs with others but the allocation
  changes dynamically.

**All but m1.small and t1.micro use assign each virtual CPU to a
dedicated physical CPU core.**

There are many good reasons to avoid CPU sharing which is why I
believe all new instance classes will only use dedicated CPU
assignment. However, since m3.medium already has one virtual CPU there
is no way to create decrease CPU count to create a smaller instance
than m3.medium except with CPU sharing. Which I assumed would not
happen. *Reductio ad absurdum*, thus no m3.small.

There could be t1.small, though. This is because the whole t1 class is
really an odd one out. I'm not sure what it is. Was it introduced as a
way to satisfy cheapskate customers? Or is it a way to get life out of
older (repurposed) hardware? Or something else? **It is useful**,
though, for running infrequently active, mostly dormant servers. Make
t1.small subject to the same bursty CPU behavior as t1.micro, but with
more oomph (shorter penalty box time). That way nobody would be fooled
into thinking that it's a decent replacement for a constant-work
server, but it would still be a good replacement for m1.small.

(Burstiness isn't that bad since nobody should be running CPU-bound
jobs in m1.small either as m3.medium offers 3× performance for 2× the
cost. The **only** real reason to use t1.micro or m1.small is when you
need an always-on, infrequently used server, and the only reason to
pick m1.small over t1.micro is either 1) really need more memory or 2)
really need a little more long-running oomph from the CPU.)

**No current plans for deprecation.** Yeah, and pigs fly.

Let's be realistic. AWS might not have **yet** a **schedule** for
deprecation, but I think someone should get their asses fired if there
are **no** deprecation plans mapped out. AWS might now just be
sounding out customer reactions to the current vs. previous generation
marketing message change before deciding on *the* deprecation plan out
of a few choices planned out. But plans there are, assure I you.

<figure> <a
href="/assets/posts/flying-pig-larry-wenztel.jpg"><img
src="/assets/posts/flying-pig-larry-wenztel.jpg" alt="flying pig"></a>

<figcaption>Surely, someday, after a lot of generic modification and
3D-printing of retro pilot glasses even pigs can fly! In style! (Image
credit: <a
href="https://www.flickr.com/photos/wentzelepsy/4435803492/">Larry
Wentzel</a>, used under Creative Commons license).</figcaption>
</figure>

**Miscellaneous.** AWS is a business. It'll keep "previous generation
instance types" around as long as it makes business sense. Conversely,
they'll be EOL'ed the day they don't make business sense.

OTOH, "business sense" isn't clear-cut and aging hardware especially
makes it complicated to evaluate. On one hand old hardware is likely
to be fully depreciated, so it's all operating profit. As long as it
actually makes money. On the other hand aging hardware breaks down
more often (it'll hit the end of the bathtub curve of reliability), it
might not work so well with more streamlined management systems and
maintenance processes and most of all, demand for it might just
drop. And you can't get "new old hardware" so any long-term plans
cannot rest on "old stuff" anyway.

Just understand that **current instance types will eventually be
deprecated/retired**. Separating "current" and "previous" instance
types is a clear step towards having a clear lifecycle for instance
types, from introduction to end-of-life status.

Which is a good thing.
