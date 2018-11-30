---
layout: post
title: "AWS & strategy over the years"
tagline: "Wardley what?"
tags: ["aws", "reinvent", "reinvent2018", "strategy"]
---

I started using and consulting on AWS somewhere around 2008. Over the
years AWS has extended its service portfolio and its geographic
presence, not to speak of the huge increase in computing and storage
capacity in all its datacenters.

While the increase in geographical reach and absolute capacity are
easy to understand --- simple response to raw customer demand --- the
updates to service portfolio require more thinking. Why this service?
Why at that particular time? Are there any clear patterns? Could you
predict future AWS services?

## Viewpoint: Adoption life cycle

One can look at AWS through the [adoption life
cycle](https://en.wikipedia.org/wiki/Technology_adoption_life_cycle),
and say that

* Initially AWS targeted innovators by producing
  **useful MVP services** (I've discussed [one aspect of this]({% post_url 2013-07-10-one-viewpoint-on-cloud %}#so-wtbf-about-startups) in 2013 and still stand by that reasoning.)
* Once "cloud" became as a viable business platform ("early
  adopters"), it broadened its service coverage.
* ... and so on ...

## Viewpoint: Developer-visible phases

I chance at another timeline categorization based on my own perception
of *using AWS services*:

1. Establishing "cloud" as a viable option for new development
   projects, offering minimal but valuable services via leveragable
   interfaces (aka APIs)
2. Pivoting towards making AWS viable for enterprises to integrate and
   later migrate existing systems to, adding more varied and less
   developer-focused services, expanding features of existing services
3. Making everybody's head spin with a plethora of overlapping and
   confusing services announced at increasingly rapid pace

The first two are clear, and I would put the dividing line between
those two phases at the the **introduction of VPC in August 2011 and
Direct Connect in September 2011**. Why? Because Direct Connect makes
more sense in integration with existing workloads in enterprise data
center than for cloud-only projects. While VPCs were useful for
cloud-native workloads, they were essential for enterprise data center
integration and Direct Connect.

This does not mean that enterprises jumped on AWS bandwagon at that
point. No no no! --- Yet, there is a strategy. Simple toe-dipping
projects can be isolated, but to do real business, enterprises needed
integration with existing CRM and ERP systems. For that, more
enterprise-oriented features came along. Eventually enterprises gained
more confidence and actually started migrating **existing** workloads
off their own data centers (an obvious progression).

## Viewpoint: Software engineers a.k.a. chaotic code cranking machines

What about the third step, the head spinning and confusion? (I alluded
this [in 2015](2015-01-03-year-of-the-cloud) when lamenting the loss
of "expert cloud generalist".)

AWS is announcing new services and new features on existing services
at an astonishing pace. Some years back I looked at AWS's open
positions, and was thinking *like why is AWS hiring all these
developers?*

*To write software*, of course. For existing services? No, while you
need *some* more people when the service is growing exponentially, the
basic tenet of cloud engineering it to create systems that *scale
well*. Neither it was tenable that AWS's retention would have been so
bad to require hiring software engineers at the pace that was apparent
from their open positions.

*To write software for **new services**.*

It often feels that AWS is overrun by engineering teams and service
ideas and cannot always produce coherent and co-working
interfaces. Maybe we are a phase where AWS usage is growing so fast,
they put resources to any development that seems to be "cloud".

This is a possibility, but it might not be true, or only a partial
truth.

## Viewpoint: It's all intentional

Another, a bit more sinister possibility is that AWS is doing the
**innovate-leverage-commoditize** (ILC) cycle faster, and faster, and
with more and more software engineers (speeding up internal
development cycle multiplied by more developers)

You really should check [Simon
Wardley's](https://blog.gardeviance.org/) work on strategy. I'll let
this one tweet from him (with pictures!) lead into why he things AWS
is getting faster.

<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">X: Why do you think Amazon is so dangerous? Don&#39;t you think they will slow down?<br>Me: No, they&#39;ll get faster.<a href="https://t.co/LiUlzyn9RZ">https://t.co/LiUlzyn9RZ</a> <a href="https://t.co/TpWmGdulaQ">pic.twitter.com/TpWmGdulaQ</a></p>&mdash; Simon Wardley #EEA (@swardley) <a href="https://twitter.com/swardley/status/924794617211572224?ref_src=twsrc%5Etfw">30. lokakuuta 2017</a>
</blockquote>

Just looking at the [ludicrous number of launches and
updates](https://web.archive.org/web/20181129181700/https://aws.amazon.com/new/reinvent/)
would appear to support better the former --- chaos ---
hypothesis. WTF satellite ground station as a
[service](https://aws.amazon.com/blogs/aws/aws-ground-station-ingest-and-process-data-from-orbiting-satellites/)?
That's hardly a high-volume low-margin business. What is next,
purchase satellites on a credit card?

On the other hand, it could be that Amazon is using AWS's momentum in
the cloud space to rush into any high-margin high technology area, and
assume it has the technological cloud and enough runway to cause chaos
and panic on incumbents in any area (satellites?). Leapfrogging to
providing lower cost, automated, self-service,
*something*-as-a-service, attempting to exploit the inherent slowness
and obstacles of existing market players.

In this context, it would not be a terrible loss if some of these
eventually fail. Why would you attempt to compete in the current
market, when you have the chance of owning the future market?

<br/>
<br/>

I am no strategist, but I've learned that most of what *appears* as
strategy is often just a retroactive narrative. What in reality was a
*jumble of intentional strategies, bunch of accidents and a lot of
groping in the dark* is often cleaned up, diced and re-assembled into
a narrative that promotes the supreme wisdom of the <strike>supreme
leader</strike> company. The question is not whether Amazon slash AWS
is chaotic. It undoubtedly is, and a lot of the history will be
written into a nice, retroactive, primetime story. Nevertheless, this
does not exclude the possibility that amid all of the chaos there is a
conscious, strategic direction being implemented.

----

(You can see all posts from re:Invent 2018 footpedalling down the
[reinvent2018](/tags.html#reinvent2018-ref) tag.)
