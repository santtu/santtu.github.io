---
layout: post
title: "Mechanics of the spot instance market"
tagline: "Where is the root of spot instances?"
tags: ["aws", "ec2", "spot instances"]
---

(You might want first see the [introduction to this series of
posts]({% post_url 2014-03-12-ec2-spot-intro %}) if you jumped in here
randomly.)

## <a name="si-mechanics"></a>Deep dive

In previous posts I've discussed about
[what are spot instances and what is the spot market]({% post_url 2014-03-12-ec2-spot-instances %})
and [what you can use spot instances for and how]({% post_url 2014-03-19-ec2-spot-usage %}). In this post I'm going to write out my thoughts
on what is the reason for spot market, its rationality and where actually
do spot instances come from.

### Purpose of the EC2 spot market

Why does spot market exist in the first place?

Spot instances were
[announced on December 14th, 2009](http://aws.amazon.com/about-aws/whats-new/2009/12/14/announcing-amazon-ec2-spot-instances/). After
that there has been several technical updates that brought spot
instances to the same level as other instance types (such as
[EMR support](http://aws.amazon.com/about-aws/whats-new/2011/08/18/amazon-elastic-mapreduce-now-supports-spot-instances/),
[VPC support](http://aws.amazon.com/about-aws/whats-new/2011/10/11/announcing-amazon-ec2-spot-integration-with-amazon-vpc/)). There
has been two major published changes on the spot market itself. First,
the
[spot market price algorithm](http://aws.amazon.com/about-aws/whats-new/2011/05/26/improved-pricing-control-for-spot-instances-coming-july-1st/)
was changed on July 1st 2011 and secondly a
[default bid price cap was introduced](http://www.mailchannels.com/blog/2013/11/aws-puts-a-cap-on-spot-instance-pricing/)
late 2013. These are the visible changes that have the name "spot
instance" on them.

What does this tell us about the purpose of the spot market?

Not yet much. But it is telling us something:

* The spot market is meaningful to AWS.
* AWS wants us to use spot instances.

But what about the **purpose**? Why did AWS go to the complication of
providing spot instances (more code, more work, more bugs) and
operating a spot market (apparent loss of pricing control) on top of
that? Why didn't it just say *"spot instances at 50% price of regular
ones"* and leave it at that?

I have not seen that AWS would have directly stated the purpose of
spot instances. All of the official information I've seen carefully
skirts about the purpose of spot instances and spot market. The
[initial announcement](http://aws.amazon.com/about-aws/whats-new/2009/12/14/announcing-amazon-ec2-spot-instances/)
tells that *"[you can] bid on unused Amazon EC2 capacity"* and the
current
[spot instance landing page](https://aws.amazon.com/ec2/purchasing-options/spot-instances/)
that *"you simply bid on spare Amazon EC2 instances"*. There are
plenty of *whys* for the customer, but no *why* for AWS itself.

I believe the groupthink of the Internet is mostly in line with the
following *hypothetised* (aka *naive*) purpose:

> Spot market is for AWS to sell excess capacity to make at least a
> bit of more money out of resources that otherwise would remain
> unused (incurring both operational and capital costs).

This seems sensible and straightforward. Yet it does not tell about
the purpose of a **spot**
market. [Dmitriy Samovskiy](http://www.somic.org/2011/08/03/amazon-ec2-spot-instances-flop/)
makes a good point about that — why are they "spot" instaces and not
"discounted" instances? It is entirely possible that AWS would have
priced "discounted instances" at -50% and left it at that (adding the
"may-be-terminated-at-any-time" clause). **Instead** the spot market
exist, with its high price volatility, spot price differences between
regions and a potential to pay up to $999.99/hour per instance. All of
this is bound to make a lot of people wary of spot instances.

Think about it. If prices were set at a fixed 50% (or 40%, or 30%)
then the element of market variability would be removed. I think a lot
of people would be more comfortable with fixed discounts over the
variability of spot market prices.

There's this thing called
["efficient market hypothesis"](http://en.wikipedia.org/wiki/Efficient-market_hypothesis)
in finance theory that posits that financial markets are "efficient"
at setting prices on traded assets. That is, the public price reflects
supply and demand in a true manner. So one possibility is that maybe —
maybe AWS thinks that it can increase its income on spot instances by
letting "the market" decide instaneous spot prices instead of a fixed
discount?

I wouldn't trust that. After all, the spot instance market is not a
real market. Bids are not open. Supply is hidden. Even the pricing
algorithm is unknown — assumptions about it being a true bidding
market have been shown to be false in the past. (All of this this and
more has been pointed out years back in
[blogosphere](http://www.somic.org/2012/04/09/how-aws-could-improve-spot-market/)
as well as in [academia](http://dx.doi.org/10.1109/CloudCom.2011.48)).

**So what is then the purpose of the spot market?**

I don't know.

I am sure that *part of its purpose* matches the naive assumption — it
is generating income for AWS that otherwise would have been
lost. Later below I'll talk about other *partial purpose* (that
surprisingly ties spot market to reserved instances), but I'm not sure
about that being the totality either.

In the end I don't know what is the purpose of the spot market. I'm
not saying that it wouldn't be *useful*. After all, you can get
substantial savings on operational cost using spot instances! You
don't have to theoretize about the purpose of rain to benefit from it,
either (in case you're a farmer).

I just don't believe that the *naive hypothesis* is all there is to.

### <a name="si-rational-market"></a>Is the market rational?

The answer is absolutely clear and simple for this one: **yes and no**.

See both above and [earlier post]({% post_url 2014-03-12-ec2-spot-instances %}#si-spot-999-dollars). The spot market
pricing algorithm is not known. I'm not going to call any market
rational whose price is potentially set by a random number generator
and the market players are finding causality
[in places where there is none](http://en.wikipedia.org/wiki/Apophenia).

Yet if you make the assumption that *the spot market price is at least
mostly a market-driven proxy of supply and demand* (and leave the
algorithm in the hands of the benevolent AWS) and ask questions about
the behavior of the bidders, then the answer is yes. Yes, at least
most of the bidders are making rational choices.

The question of AWS spot market's rationality is a common question
(see
[here](http://blog.bright.com/2013/10/24/increased-pricing-volatility-due-to-irrational-actors-in-the-aws-spot-instance-market/),
[here](http://stackoverflow.com/questions/5774477/on-amazon-ec2-will-the-spot-instance-price-ever-be-higher-than-the-on-demand-pr)
and
[here](http://www.somic.org/2012/01/10/on-amazon-ec2-spot-price-spikes/)). Although
the famous $999.99 spike was probably a genuine human mistake
(e.g. not rational), it is still useful to ask why anyone would bid
over the price of an on-demand instance. A lot of people think it is
not logical. Yet this does really occur all the time. Is the net full
of loonies or not?

<small>(Yes it is. But let's consider the spot market only, shall
we?)</small>

[Earlier]({%post_url 2014-03-19-ec2-spot-usage%}#si-spot-over-bidding)
I've pointed out that the total costs of running a spot instance can
easily be less than the cost of using equivalent on-demand instance
**even when you bid at 10x the on-demand price**. Thus at least for
those cases where you can **expect** (based on past history, which of
course is not indicator of future blah blah blah) likely savings with
high bids then it is entirely rational to bid at >1x prices.

But then what about `c3.2xlarge` in `us-east-1`? See the graph below:

<figure>
<a href="/assets/posts/spot-weekly-c3.2xlarge-us-east-1.svg"><img
src="/assets/posts/spot-weekly-c3.2xlarge-us-east-1.svg"
alt="c3.2xlarge in us-east-2"></a>

<figcaption>Daily average and maximum prices for
<code>c3.2xlarge</code> spot market prices in
<code>us-east-1</code>. Solid line is the weighted daily average
price, lineless blocks are the maximum daily bid price and colors
represent different zones.

</figcaption>

</figure>

Although not we have the benefit of hindsight, I think anyone bidding
for `c3.2xlarge` during January 2014 would have quickly realized that
they are **not** getting an instance at on-demand prices. Why then?

The `c3` class of instances was announced in November 2013 and from
the very beginning
[demand for them was high](http://www.stackdriver.com/aws-c3-instance-adoption-follow/). In
fact, demand was higher than supply. For anyone familiar with economy
101 this is a case of
[supply vs. demand](http://en.wikipedia.org/wiki/Supply_and_demand)
where the price of a good should rise when demand is higher than its
supply. Yet the on-demand instance pricing is
[not elastic](http://en.wikipedia.org/wiki/Elasticity_(economics) and
cannot be changed rapidly by AWS to match the unexpected demand (AWS
can change the price, but I don't think they want to increase the
price for PR reasons).

You can see where this is going, right? Spot market price is elastic,
and in this case it clearly shows that when demand outstrips supply,
the per-unit price increases. In the graph above you can see that
`c3.2xlarge` prices have started to fluctuate and on average, have
gone down since late February. This is most likely due to AWS being
able to introduce capacity faster than the demand has increased. (An
alternative interpretation is that a lot of those interested in
`c3.2xlarge` have become disillusioned at its (un)availability and
gone elsewhere.)

But **why would anyone pay >1x cost for an instance**? There are,
after all, plenty of other instance types (even in the `c3` class)
that are available at on-demand prices from either on-demand or spot
markets. Why?

I have no idea what goes in bidder's heads. But there are a few
possibilities that are entirely rational that come to my mind:

* Someone values uninterrupted service over savings. See BrowserMob's
  bidding strategy at
  [4:00 in this video](http://www.youtube.com/watch?v=WD9N73F3Fao#t=239). They
  clearly put a large weight into getting the resources *now* even at
  higher price than *later* and cheaper.

* Someone tests how their application runs on `c3` instances. They
  might be contemplating moving a production environment over (c3 is
  cheaper than m1… at regular prices). Doing a time-limited
  performance evaluation even at the overpriced spot market prices
  isn't going to break your bank and would provide you with valuable
  information for the future (e.g. will you buy `c3` reserved
  instances or not).

I'm sure there are others, but eventually they all boil to the same
conclusion: **buying at high cost in the spot market is rational if
doing so offers larger potential benefits than waiting to buy at
regular prices later**.

### Spot market price drivers

Although we don't know the actual spot price algorithm, it is possible
to observe it and see whether its behavior correlates with other,
known events.

When talking about the spot market algorithm the first stop most
definitely has to be a paper called
[Deconstructing Amazon EC2 Spot Instance Pricing](http://dx.doi.org/10.1109/CloudCom.2011.48)
by Beh-Yehuda et al (2011). The researchers did a very thorough
analysis of AWS spot instance market and the spot price behavior. Even
though most of the analysis is using data prior to the 2011 pricing
mechanism change and *thus is not valid today* it is still a good
read. Especially the bit in epilogue where the researches state that

> *"While these radical qualitative changes
> [June 2011 pricing mechanism change] are further evidence of the
> former prices being artificially set, the October prices are
> consistent with a constant minimal price auction, and are no longer
> consistent with an AR(1) hidden reserve price."*

So … AWS didn't use a "market" algorithm before, but they seem to be
using one today. As a working hypothesis I'll take it that there is
*some* market-based price algorithm that takes some inputs and outputs
a spot instance price. What are the inputs?

* One thing that we know is that *"the Spot price will raise when our
  [AWS] capacity lowers."* and *"the increase in the m2.2xlarge Spot
  price today [the $999.99 price spike event] was related to an sudden
  increase in demand for On-Demand m2.2xlarge instances which
  significantly depleted the unused capacity.*"
  ([source](https://forums.aws.amazon.com/message.jspa?messageID=281838#281838)).

  **Available EC2 instance capacity affects spot price.**

* From looking at the
  [`c3.2xlarge` spot price graph](/assets/posts/spot-weekly-c3.2xlarge-us-east-1.svg)
  it should be also obvious that demand has an effect. When
  considering also quotes above it is possible to infer that:

  **Demand for EC2 instances affects spot price.**

* <strike>There is also a *minimum bid price* set by AWS. If you try to bid
  below this you'll get a `price-too-low` error with a message *"Your
  Spot request price of 0.02 is lower than the minimum required Spot
  request fulfillment price of 0.403."* (numbers naturally vary).

  **There is a minimum spot price**, which varies by instance type and
  region. (I am not sure about zones.)</strike>

  (Updated 2014-03-25) Wrong wrong wrong! The `price-too-low` message
  is really only talking about current spot price. My bad. However
  there still appears to be minimum spot prices which I go through
  [in the next post in this series]({% post_url 2014-03-25-ec2-spot-price-minimum %}).

* AWS has a default maximum bid limit of 4x on-demand price *but this
  is a soft limit and can be raised or removed*. The maximum relative
  bid price varies, but in the data set I have there are several
  instane types with >50x spot prices. This implies that there are
  bids at that level *and potentially higher*.

  **It is not known whether there is *any* spot price upper limit.**

  <small>(If anyone is brave enough to do a short bid at 10000x price
  level I'm interested in hearing about the results.)</small>

In the next section I'll talk about my hypothesis about where spot
instance capacity comes from, but from Dave@AWS's quotes and other
observations it should be clear that spot market price is affected by
demand on all instance types, including on-demand and reserved
instances. That is, an increased demand for on-demand instances may
affect spot market price even when no changes occur in the spot market
bid pool.

It seems reasonable to assume all of the above affect prices. But this
doesn't remove the possibility of other price drivers. It is entirely
possible that AWS would artificially push the spot price up (to
maximize their profits — 50x0.99 is more than 100x0.20) *or* depress
the price (to make spot instances more appealing?). *Or* an increase
in the capacity is fed to the pricing engine slowly to prevent rapid
price fluctuations. Or a decrease in capacity is pre-factored so that
it is removed in steps instead of a large drop (and matching rapid
price increase). Or …

### <a name="si-spot-source"></a>Where do spot instances come from?

**Note:** Most of this section is pure speculation. I am presenting a
hypothesis about AWS's division of instance resources which may be
completely wrong. However as far as I'm concerned it is a hypothesis
that is in line with actual observations.

The official statement from AWS is that the capacity for spot
instances is *"spare Amazon EC2 instances*"
([source](http://aws.amazon.com/ec2/purchasing-options/spot-instances/)). A
bit more verbose is
[Dave@AWS's commentary](https://forums.aws.amazon.com/message.jspa?messageID=281838#281838)
in the AWS forums:

> *"To answer your second question, you asked what other capacity
> pools could be a part of Spot. Behind the scenes, our goal is to
> have all of Amazon EC2's unused capacity integrated into Spot. By
> optimizing the use of these instances, we hope to be able to pass
> along more savings over time to our customers. Selling our unused
> capacity means we may leverage unused capacity from other pools like
> On-Demand or <b>other parts of our capacity that can be temporarily
> sold but may need to be reclaimed at a later time</b>. It would take
> precedence over On-Demand, because we do not have the ability to
> reclaim On-Demand instances, so they cannot be sold there."*
> (Emphasis is mine.)

Let me go through behaviors associated with the main instance types:

<figure>
<table>
<thead>
<tr><th>Instance type</th><th>Guaranteed availability</th><th>Arbitrary termination</th></tr>
</thead>
<tbody>
<tr><td>On-demand instance</td><td>No</td><td>No</td></tr>
<tr><td>Reserved instance</td><td>Yes</td><td>No</td></tr>
<tr><td>Spot instance</td><td>No</td><td>Yes</td></tr>
</tbody>
</table>
</figure>

(Notice how reserved instances and spot instances are complementary to
each other.) Although AWS may have other (internal?) capacity pools
with other access constraints, I think that "unused" capacity at any
moment can be divided into two sets: one that can be used for
on-demand instances and one that **cannot** be used for on-demand
instances. This is because of the semantics of reserved instances.

> *"Reserved Instances provide a capacity reservation so that you can
> have confidence in your ability to launch the number of instances
> you have reserved when you need them."*
> ([source](https://aws.amazon.com/ec2/purchasing-options/reserved-instances/))

When you purchase a reserved instance **you have no obligation to run
it**, but AWS has an obligation to provide you with a reserved
instance any time you **want to run it**. This means that any reserved
instance that *is not running* could be sold, but *not* as an
on-demand instance since AWS cannot evict an on-demand instance at
will. See the figure below (which doesn't have too many non-negations):

<figure>
<a href="/assets/posts/ec2-capacity-categorized.svg"><img
src="/assets/posts/ec2-capacity-categorized.svg"
alt="ec2 capacity pools"></a>

</figure>

At any moment in time AWS's total capacity is split into running
instances and unused capacity. Running instances are further divided
by type into reserved instances, on-demand instances and spot
intances. The pool of unused capacity has a portion which **cannot**
be sold as on-demand instances (because if it was sold and a lot of
powered-off reserved instances were started it might not be able to
provision resources for all those reserved instances). Thus **there is
unused capacity that can only be sold as spot instances.**

This also means that there **can be unused spot instance capacity even
when on-demand instances cannot be provisioned**. So finally we can
explain why `c3.2xlarge` instances could be purchased from spot market
even when you couldn't buy on-demand instances: there was a pool of
`c3.2xlarge` reserved instances already sold that were **not powered
on**.

When reserved instances are powered on I think this is what happens:

1. If there is unused capacity, it is used to provision the reserved
   instance. End of story.

2. If no unused capacity was available, the spot market is notified
   that it needs to release capacity from the spot pool.

3. Spot market algorithm recalculates the spot price based on the new
   (reduced) total capacity. If this changes the spot market price
   then it'll terminate those spot instances whose bid price fell
   below the spot market price. The released instance capacity is
   allocated back to the reserved instance.

   What happens if the change of the capacity does not change the spot
   price? I'm not sure. It might be that the spot market algorithm
   will forcefully increase the spot price. As well it might not. The
   exact wording from AWS is *"If the Spot price exceeds your max bid
   or there is no longer spare EC2 capacity in a given Spot pool, your
   instances will be terminated."* which *I think* leaves open the
   possibility that a spot instance is terminated also on capacity
   decrease even when the bid price doesn't change.

*If anyone has had their spot instance terminated even when the bid
price equals spot price I'd be delighted to hear about your
experiences.*

(It is possible that there are also *other* pools of resources that
are available for spot market use. Maybe new servers are first
assigned to a "burn-in pool" which is sold only via the spot
market. Maybe AWS has internal testing pools that are available for
customers when not needed. I have not seen anything that would suggest
so, though.)

### Market efficiency and reserved instances

If my hypothesis about that powered-off reserved instance capacity is
sold in the spot market then (I claim) that spot market is essential
for AWS to maximize its income from reserved instances.

You could say that **a working spot market is a requirement for
reserved instances**.

Think about it. If AWS was not able to resell unpowered reserved
instances then it would be making loss with reserved instances. The
`c3.8xlarge` light usage reserved instance upfront cost is $2666. It
has 32 (virtual) cores and 60 GiBs of memory so I think that
`c3.8xlarge` represents almost a physical single server (each
E5-2680v2 has 20 threads, which I guess maps to an EC2 core) and **I'm
pretty sure it'll cost more than $2666**.

If AWS was not reselling unpowered reserved instance capacity then
anyone buying a light utilization reserved instance would most likely
end up costing AWS concrete and real money. At the minimum it would
make the gross margin on those physical servers very low.

### Open questions

I have a hypothesis. Good hypotheses can be tested with tests that
either falsify the hypothesis or give results that are in line with
earlier predictions.

Actually, to be accurate, I have two hypothesis. The first one is that
**spot market price is affected by supply and demand for all types of
EC2 instances** (also that there is a minimum spot price and there is
no maximum spot price but we know the first for a fact and I'm not
sure the second one is meaningful to explore at all).

The second one is that **unused but purchased reserved instance
capacity is re-sold as spot instances**.

I'll infer from these that the spot market should behave in the
following manner (all of these apply to each region, instance type and
availability zone separately):

* Unpowered reserved instances and stopped on-demand instances should
  not affect spot price.
* Purchasing reserved instances (without powering them on) …
    * … should not affect spot price.
    * … should decrease unused on-demand instance capacity. (This of
      course may not be visible in any way.)
    * … should increase unused spot instance capacity.
* Powering reserved instances on …
    * … may increase spot price.
    * … may cause spot instances to be terminated (even when spot
      price remains unaffected).
    * … should not affect availability of on-demand instances.
* Powering reserved instances off …
    * may decrease spot price.
* Provisioning new on-demand instances or starting stopped on-demand
  instances …
    * … may increase spot price. (We already know via AWS forum
	  comments about the $999.99 spot price spike that demand for
	  on-demand instances can affect spot market prices. It is not
	  clear what the mechanism here is though — does AWS
	  preferentially give capacity to on-demand requests?)
    * … may cause spot instances to be terminated. (See previous.)
* Terminating on-demand instances or stopping on-demand instances may
  decrease spot price.

That's a lot. How could these be tested? First and foremost, testing
any of these is potentially **expensive** as you need to provision
instances and put in bids for spot instances and you'll need to pay up
for all of that. (These might also violate AWS's
[Acceptable Use Policy](http://aws.amazon.com/aup/).) It might be
possible to infer some of this data from actual spot market logs
and/or other monitoring data, though how I don't know.

* Buy one or more reserved instances. Start reserved instances. Based
  on the hypothetised behavior this should cause the spot market price
  to either increase or remain the same.

  (Given that there are other people powering instances on and off
  this would show up only as a statistical result from many
  iterations. This applies to all other tests too.)

* Power off reserved instances. This should cause the spot market
  price to decrease or remain the same.

* Purchase spot instances at spot market price or slightly above. See
  how often their termination is associated with spot price
  increases. (Some of them should not be.)

* Purchase spot instances at spot market price. Power on reserved
  instances. There should be a correlation between starting your
  reserved instances and termination of your spot instances.

* Start on-demand instances. This may be correlated with spot price
  increase.

* Stop on-demand instances. This may be correlated with spot price
  decrease.

Of course testing any of these is fraught with difficulty. Starting
and stopping one instance is unlikely to affect the spot market price
(the system would have to be near a transition point) and any result
could be swamped badly by random effects (other users). You could
reduce environmental noise by choosing relatively unused region, zone
and instance type but in that case you'd probably have to purchase a
significant number of instances to see *any* effect.

### How does this affect you?

Not really much. You shouldn't try to second-guess future behavior of
spot prices.

If my hypothesis is correct, then you might want to keep in mind that
the spot market price is affected by events that occur outside the
spot market. That is even an apparently stable market can change
suddenly *without any change in the bidding pool*.

But you already knew that spot market is volatile, didn't you? No new
news, then.

Here's the [next post in the series]({% post_url 2014-03-25-ec2-spot-price-minimum %}).
