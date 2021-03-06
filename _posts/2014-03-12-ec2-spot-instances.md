---
layout: post
title: "Spot instances and price behavior"
tagline: "What, when and at what price?"
tags: ["aws", "ec2", "spot instances"]
excerpt: false
date: 2014-03-12 16:00:00 +02:00
---

(You might want first see the [introduction to this series of
posts]({% post_url 2014-03-12-ec2-spot-intro %}) if you jumped in here
randomly.)

## <a name="si-market"></a>Spot instances and the spot instance market

I'm covering the basics of what spot instances are (e.g. how they
differ from on-demand and reserved instances), what is the spot price,
what are its characteristics and how the spot price and the bid price
affect availability of spot instances (from bidder's point of
view). Finally I'm discussing a famous $999.99/hour instance pricing
event.

A lot of the information in this section can be found in [AWS's own
spot instance
documentation](https://aws.amazon.com/ec2/purchasing-options/spot-instances/). Most
of the graphs have been generated by me using 90 days of spot pricing
data from December 9th 2013 to March 9th 2014.

### What are spot instances?

For the purpose of computation, spot instances are like any other
instance type AWS offers. Where they differ is that **you do not have
a complete control on the lifecycle of spot instances**.

> **Spot instances can be terminated by AWS at any time.**

(**Edit 2015-01-06**:
[AWS announced](https://aws.amazon.com/blogs/aws/new-ec2-spot-instance-termination-notices/)
a two-minute termination notice available via instance metadata. You
still can't prevent termination, but you do not get a short notice
before it occurs.)

With on-demand instances (the regular variety) and reserved instances
you get to choose the lifetime of the instance. With spot instances it
is you **and AWS** who get to terminate the instance. AWS of course
plays by the market rules so any loss of spot instances is not
arbitrary although it may sometimes seem like so (because not all
variables that affect the market are visible).

**Why would anyone use spot instances then?** Simple: cost. Spot
instance prices are variable but on average they offer **significantly
lower prices** than with on-demand prices. With spot instances it is
possible to get same savings as with 3 year heavy usage reserved
instances offer without the up-front costs.

If you can structure your computing needs around the potential
arbitrary instance loss then you can gain substantial benefits from
using spot instances. AWS's own marketing material references to
customer cases with 50-60% savings on instance costs.

> Spot instance prices cover only EC2 instances. Other
> instance-related resources such as network traffic and EBS usage by
> the instance is billed at regular rates.

To recap:

* Spot instances are functionally equivalent to other types of instances.
* Spot instances may be terminated at any time by AWS.

### What is the spot instance price?

First of all, spot instances are priced **by instance type, by region
and by availability zone in that region**. This means that spot market
price for `m1.small` differs from zone to zone even within a single
region, not alone between regions.

Neither is spot instance pricing fixed. It varies over time and is
determined by the *AWS spot market*. The market is essentially an
auction where buyers (spot instance users) submit **bids**. AWS
determines the spot instance price based on these bids and then

1. Everyone with a bid higher or equal to the resulting spot instance
   price "wins" and gets the instances they requested (or keeps them,
   in case they already exist), and

2. Winners pay for the **spot instance price** and not their own bid
   (e.g. everyone pays the same value which may be lower than their
   bid).

Note that anyone **losing their bid** either will not get their
instances or will get their **existing spot instances terminated**.

Spot market is a continuous auction where the spot instance price is
continuously updated. The update interval may be anything from minutes
to days, depending on the supply of instance capacity and demand for
spot instances.

You can see spot market price history in the [AWS management
console](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-spot-instances-history.html). Here's
a typical graph you can get:

![Sample spot price history graph from AWS management console](/assets/posts/spot-instance-price-history-management-console.png)

You can twiddle the settings in the UI, but you are limited to 90 days
of pricing history.

<small>Finally for the sake of completeness (but don't worry, this
won't part of the quiz) understand that the actual bidding process is
a bit more complicated than saying "I bid for c1.medium at
$0.050". You can bid for multiple instances, specify validity time for
the bid, zones to bid in, enable persistent bid requests — and of
course you'll also need to specify all the other parameters needed to
launch an instance (instance type, AMI, disks and so on). Finally you
can put in as many separate bids as you like.</small>

To recap:

* Spot instance price is variable and is determined continuously by
  AWS based on how customers bid for spot instances.
* Each region, availability zone and instance type is a separate
  market for the purpose of pricing.
* Whether you get or lose spot instances is determined whether your
  bid is equal to or larger than the current spot price.
* You pay only the current spot price regardless of your bid price.

### How do I actually buy spot instances?

[RTFM](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-spot-instances-bid-management.html)
or watch [this video](http://www.youtube.com/watch?v=Py0VInjRSBE).

### Price volatility

Spot prices are **volatile** — they go up, they go down, they go
sideways and all at the same time. I'm no economist and can't give you
an exact definition of volatility, but please take a look at the graphs
shown below:

<figure class="full">
<a href="/assets/posts/instance-price-volatility-example.svg"><img class="double" src="/assets/posts/instance-price-volatility-example.svg" alt="c1.medium vs. cc2.8xlarge price volatility differences"></a>
<a href="/assets/posts/zone-price-volatility-example.svg"><img class="double" src="/assets/posts/zone-price-volatility-example.svg" alt="c1.medium volatility across zones in us-east-1"></a>

<figcaption>Examples of price volatility difference between instance
types (on left) and between different availability zones (on
right). Vertical axis is logarithmic, in units of on-demand instance
pricing. Solid lines are daily averages and the translucent blocks
show the daily maximum price. Different colors represent different
availability zones. Faint gray horizontal lines correspond to 4x, 1x
and 1/4x price compared to on-demand instance pricing. Click images
for larger versions.

</figcaption>

</figure>

From these images it should be clear that there are differences in
volatility, minimum and maximum prices, average prices etc. between
instance types (left image) where the overall volatility for
`c1.medium` is high over the whole data period, but for `cc2.8xlarge`
there is a clear and persistent volatility drop on January 8th.

There can be significant volatility between different availability
zones in the same region (right image) where the price for `c1.medium`
has been pretty stable and low in two zones (zones 1 and 2). This
isn't the case with all of the other zones (3 to 5) where both daily
averages (solid line) **and** the maximum daily price (lightly colored
blocks in the background) vary massively from day to day.

Yes, in the graphs above the **daily average prices are over 10x the
on-demand instance pricing on several days** with spikes even
higher. In the above graphs the weighted average price for `c1.medium`
instance in zone 2 is $0.0184 and for zone 3 $0.3174. The regular
on-demand instance price for `c1.medium` in `us-east-1` is $0.145 per
hour. This may give you a WTF moment but see below. I'm going later to
discuss one situation where [bidding over the on-demand
price](#si-spot-availability) would have been a reasonable strategy
*post hoc*.

> AWS assigns a random permutation of availability zones
  for each customer account. In plain English this means that **my**
  `us-east-1a` might be **your** `us-east-1d`. It's a common tripping
  point when comparing metrics related to zones between different
  accounts. This is also why I omit zone labels from the graphs.

To recap:

* Prices can both vary widely, up to multiple times the price
  of equivalent on-demand instance.
* Price volatility can vary massively between instance types in the
  same region, and between availability zones for the same instance
  type in the same region.

### <a name="si-spot-availability"></a>Instance availability is determined by bid prices

> **IMPORTANT**: All of the graphs below use *post hoc* analysis. The
  theoretical maximums on availability and price savings would be
  possible to achieve **only if you can predict the future!**

So far I've said that spot instances may be terminated at any time the
spot price goes over your instance bid price. This doesn't yet tell us
what is the typical **expected** lifetime (which in turn determines
availability) of an instance based on a particular bid.

There is research into algorithms to optimize availability
vs. cost. See [Mazucco and Dumas
(2011)](http://dx.doi.org/10.1109/HPCC.2011.46), [Andrzejak et al
(2010)](http://dx.doi.org/10.1109/MASCOTS.2010.34), [Wee
(2011)](http://dx.doi.org/10.1109/CCGrid.2011.38) and [Ben-Yehuda et
al (2013)](http://dx.doi.org/10.1145/2509413.2509416). The last one
(Ben-Yehuda et al) is probably the most thorough in considering price
vs. availability tradeoffs. **Be careful** when interpreting
conclusions from these and other papers as most of them use data prior
to the [July 1st 2011 change of spot market pricing
mechanism](http://aws.amazon.com/about-aws/whats-new/2011/05/26/improved-pricing-control-for-spot-instances-coming-july-1st/).

The figure below shows how **achievable availability** varies with the
normalized bid price for two types of instances and availability
zones. <small>(I'm calculating availability instead of expected
lifetimes just because it's easier. A value for expected lifetime as
well as number of interruptions versus bid price would be interesting,
though.)</small>

<figure>
<a href="/assets/posts/achievable-availability-example.svg"><img src="/assets/posts/achievable-availability-example.svg" alt="Achievable availability for c1.medium and cc2.8xlarge vs. bid price"></a>

<figcaption>

Example showing <b>theoretically</b> achievable availability versus
normalized bid price with <code>c1.medium</code> and
<code>cc2.8xlarge</code> in the <code>us-east-1</code>
region. Vertical lines correspond to 1/4x, 1x and 4x on-demand
instance price.

</figcaption>
</figure>

This shows that sometimes it is possible to get 100% availability at
less than on-demand instance bid price — look at the purple line for
`c1.medium` which hits 100% at bid price of 98% × on-demand price and
99.9% availability at bid price of 32% × on-demand price. But wait,
there's more! Remember that you don't pay the bid price but the market
price!

The figure below is otherwise identical to the one above with the
exception that horizontal axis is the relative **total cost** (… over
the whole data period analyzed — the result over any other random
range of dates will be different).

<figure>
<a href="/assets/posts/achievable-availability-cost-example.svg"><img src="/assets/posts/achievable-availability-cost-example.svg" alt="Achievable availability for c1.medium and cc2.8xlarge vs. total cost"></a>

<figcaption>

Example showing <b>theoretically</b> achievable availability versus
normalized cost. Note that even when the bid price might have to be
substantially higher than on-demand price to gain 100% availability
the total cost can still be less.

</figcaption>
</figure>

This shows that even when you'd have to bid for `cc2.8xlarge` at about
4× on-demand price to achieve 100% availability, that availability
would have **cost** you less than 73% of the total on-demand instance
cost (that is, over the 90 days of the sample data).

Finally, as a bad cost case example see the figure below:

<figure>
<a href="/assets/posts/worst-case-availability-cost-example.svg"><img src="/assets/posts/worst-case-availability-cost-example.svg" alt="Availability vs. total cost c3.2xlarge"></a>

<figcaption>

Availability vs. total cost for <code>c3.2xlarge</code> in
<code>us-east-1</code> over the data period. It is not possible to
achieve even 50% availability without paying substantially more than
for equivalent on-demand instance.

</figcaption>
</figure>

During the time period this data set covers it was not possible to
achieve any level of reliability for `c3.2xlarge` instances without
paying substantially more than the equivalent cost for an on-demand
instance.

**Why would anyone pay >1× rates?** During this particular time period
there was a shortage of on-demand and reserved `c3.2xlarge` capacity,
so the only way to get such an instance was to bid high in the spot
market. This is classic supply and demand equation — at the moment
there is very limited supply of this instance type, yet there is
demand and people are willing to pay. (Why there are instances
available in the spot market while not in the on-demand market is a
topic I'll cover in a later post.)

To recap:

* Your bid price determines not only whether you get a spot instance
  in the first place, but also how long acquired spot instances stay
  alive.
* **You control your spot instance's availability through bid
  prices.**

### <a name="si-spot-999-dollars"></a>Instances at $999.99/hour

On September 2011 there was a huge price increase in one zone of the
`us-east-1` region for `m2.2xlarge` instances where the spot market
price jumped from about $0.44 to $999.99 per hour.

**What happened?**

* Someone had put in $999.99 bid
* Spot instance capacity / demand changed rapidly (Dave@AWS: *"an
  sudden increase in demand for On-Demand m2.2xlarge instances"*)
* Some poor sod ended up paying $999.99 per hour for their spot
  instances.

To understand why this could happen, let's try to imagine what the
situation might have been in the "bidding pool" (the set of bids on
the `m2.2xlarge` spot capacity) before the price hike in a quite
artificial setup with only a few bidders and total supply of just five
spot instances:

[![Before the $999.99 price hike](/assets/posts/999.99-spot-price-event-low-price.svg)](/assets/posts/999.99-spot-price-event-low-price.svg)

One possible bidding scheme is to allocate capacity to bids in
highest-bidder-first with the final spot price being determined by the
lowest winning bid. Thus in this situation the person with $999.99 bid
will still pay $0.200 per hour.

If this person now needed three more instances at the same bid price,
then the bidding scheme would work like this:

[![Before the $999.99 price hike](/assets/posts/999.99-spot-price-event-high-price.svg)](/assets/posts/999.99-spot-price-event-high-price.svg)

BOOM!

In reality we don't know why the bid price rose as **AWS does tell us
how the spot price is determined**. It is supposed to be based on some
form of auction model, but it might not be. See [Achieving Performance
and Availability Guarantees with Spot Instances](http://dx.doi.org/10.1109/HPCC.2011.46) by Mazucco et al
which discusses bidding schemes and server allocation policies that
maximize the **seller's profit**.

The best description on how the spot price is determined is *"The Spot
Price is set by Amazon EC2, which fluctuates in real-time according to
Spot Instances supply and demand"*
([source](https://aws.amazon.com/ec2/purchasing-options/spot-instances/)). Without
AWS disclosing the actual algorithm it is entirely possible that it is
**not** even remotely following the simple auction model described
above. It could be really out to maximize AWS's revenue — in the
previous case the algorithm could have realized that at that
particular moment profit would be maximized with the absurd
$999.99/hour spot price! <small>(Though I do think that this behavior
took AWS by surprise too. I think they fell into the theoretical trap
of assuming that people participating in market are all rational
players, where in reality they often are not.)</small>

This is however pure speculation. From a buyer's perspective the spot
market does work as it statistically does provide cheaper resources
than the on-demand market.

AWS has since added [a cap on the bid
price](http://www.mailchannels.com/blog/2013/11/aws-puts-a-cap-on-spot-instance-pricing/)
(see [also
here](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-spot-limits.html)),
limiting potential accidents like this. The default cap limit is 4x
the equivalent on-demand instance price, but it can be increased and
clearly has been increased by some bidders (see [this
graph](http://localhost:4000/assets/posts/zone-price-volatility-example.svg)
and note how the maximum and average daily prices have been over 4x
several times).

Regardless of the cap **you should bid only what you are willing to
pay**.

> For more information on the actual event, please see [brandon's
> early
> report](http://devblog.moz.com/2011/09/amazon-ec2-spot-request-volatility-hits-1000hour/)
> in devblog.moz.com, a later analysis by [Jonathan Boutelle from
> Slideshare](http://gigaom.com/2011/12/27/how-to-deal-with-amazons-spot-server-price-spikes/)
> and [Dave@AWS's responses on the
> event](https://forums.aws.amazon.com/message.jspa?messageID=281838#281838)
> in the AWS discussion forum.

To recap:

* Bid only what you can bear.

### Further reading

You can find a ton of resources on AWS spot instances and the spot
instance market on the net. Here are a few web pages, articles and
research papers I've found useful:

* AWS's own landing page on [spot
  instances](https://aws.amazon.com/ec2/purchasing-options/spot-instances/)
* Pretty comperhensive [set of
  videos](http://aws.amazon.com/ec2/purchasing-options/spot-instances/spot-tutorials/)
  from AWS on spot instances
* Slides from [Saving with Spot
  Instances](http://www.slideshare.net/AmazonWebServices/cpn203saving-with-spotfinal-15492709)
  session in re:Invent 2012 ([here's the
  video](http://www.youtube.com/watch?v=zDrLeHlamvY) to go with it,
  although the slides are more compact)
* [Deconstructing Amazon EC2 Spot Instance
  Pricing](http://dx.doi.org/10.1145/2509413.2509416) by Ben-Yehuda et
  al — remember to read epilogue on page 19!

Here's the [next post in the series]({% post_url 2014-03-19-ec2-spot-usage %}).
