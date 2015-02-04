---
layout: post
title: "Minimum spot instance prices"
tagline: "Drawing numbers out of thin air"
tags: ["aws", "ec2", "spot instances"]
---

(You might want first see the [introduction to this series of
posts]({% post_url 2014-03-12-ec2-spot-intro %}) if you jumped in here
randomly.)

**Warning:** This article is really about splitting hairs. If you
think watching paint dry is boring then this post most probably isn't
for you.

In my [previous post]({% post_url 2014-03-20-ec2-spot-market %}) I
stated that AWS has set minimum spot instance prices and incorrectly
asserted that these minimums are can be seen in the `price-too-low`
error when submitting low bids. **This is wrong** (I've updated the
earlier blog post slightly to avoid spreading the wrong fact), as the
"minimum" bid price given is actually the current spot price. Oh, how
could I miss *that*.

### How to find a minimum spot price

Thus there is no direct way to get the *minimum spot price* in any
market. But it is possible to infer these indirectly from spot price
history data? I looked at the **minimum spot prices** in all regions
and instance types (picking the lowest of all zones) and plotted it
getting the graph below (the dataset spans 2013-12-08 to 2014-03-09):

<figure class="full">
<a href="/assets/posts/minimum-spot-price-all-regions.svg"><img
src="/assets/posts/minimum-spot-price-all-regions.svg" alt="minimum
spot prices by instance type in all regions"></a>

<figcaption>Minimum spot market prices by instance type and
region. The minimum is calculated over all the zones in the
region. Note that `cc1.4xlarge` is missing due to a
limitation in the source data, not that it doesn't have
bids.
</figcaption>
</figure>

Take a look at the graph for a few seconds. Go ahead. Don't skip ahead
until you've taken a bit of time to look at the dots. Okay, let's
continue then. I think you have also noticed there are
*patterns*. There is a distinct pattern for several instance types in
the data — `m3.xlarge`, `m3.2xlarge`, `t1.micro` for example, but also
continuing over the `m1` and `m2` classes. There may be another
pattern with some `c3` instance types and maybe yet another for `m3`
too, but let's stick with the most obvious one for now. I'll label the
set of "similar" minimum price pattern the *"suspect"* group. Below is
a plot with all of the "suspect" instance types (minimum relative
prices) plotted on top of each other:

<figure>
<a href="/assets/posts/minimum-spot-price-suspects.svg"><img
src="/assets/posts/minimum-spot-price-suspects.svg" alt="minimum
spot prices of selected instances overlaid by region"></a>

<figcaption>Minimum spot price for instance types
`m3.xlarge`, `m3.2xlarge`,
`t1.micro`, `m1.large`, `m1.xlarge`,
`m2.xlarge`, `m2.2xlarge`,
`m2.4xlarge`, `m1.small`,
`m1.medium`, `c1.medium` and
`c1.xlarge`. Different colors correspond to different
instance types. Y-axis positions are slightly jittered.

</figcaption>
</figure>

This graph requires a bit of thought to understand so bear with
me. These are *relative minimum spot prices* so although the
*absolute* minimum spot price differs from region to region these
should be comparable to each other. In the graph there are two things
that you need to be considered:

* **Similarity** between regions. It is quite clear that
  `ap-southeast-1`, `ap-southeast-2` and `us-west-1` are almost
  identical to each other. With eyes squinted `us-west-2` has a
  cousin-style similarity to these three but all of the others are
  definitely dissimilar.

* **Levels** of the relative prices. You can find the cheapest spot
  instances (for the instance types discussed) in `us-east-1` whereas
  `ap-northeast-1` and `eu-west-1` are clearly more expensive (err…
  less cheap?). All of the others seem to have roughly similar average
  minimum level.

What I find *very interesting* is the identical levels and structure
between the three topmost regions. Here's the raw data from these
three regions in a tabular format:

<figure>
<table>

<TR> <TH>  </TH> <TH> us-west-2 </TH> <TH> ap-southeast-1 </TH> <TH> ap-southeast-2 </TH>  </TR>
  <TR> <TD align="right"> c1.medium </TD> <TD align="right"> 0.028 </TD> <TD align="right"> 0.028 </TD> <TD align="right"> 0.028 </TD> </TR>
  <TR> <TD align="right"> c1.xlarge </TD> <TD align="right"> 0.112 </TD> <TD align="right"> 0.110 </TD> <TD align="right"> 0.110 </TD> </TR>
  <TR> <TD align="right"> m1.small </TD> <TD align="right"> 0.010 </TD> <TD align="right"> 0.010 </TD> <TD align="right"> 0.010 </TD> </TR>
  <TR> <TD align="right"> m1.medium </TD> <TD align="right"> 0.021 </TD> <TD align="right"> 0.020 </TD> <TD align="right"> 0.020 </TD> </TR>
  <TR> <TD align="right"> m1.large </TD> <TD align="right"> 0.042 </TD> <TD align="right"> 0.040 </TD> <TD align="right"> 0.040 </TD> </TR>
  <TR> <TD align="right"> m1.xlarge </TD> <TD align="right"> 0.083 </TD> <TD align="right"> 0.080 </TD> <TD align="right"> 0.080 </TD> </TR>
  <TR> <TD align="right"> m2.xlarge </TD> <TD align="right"> 0.056 </TD> <TD align="right"> 0.059 </TD> <TD align="right"> 0.059 </TD> </TR>
  <TR> <TD align="right"> m2.2xlarge </TD> <TD align="right"> 0.112 </TD> <TD align="right"> 0.118 </TD> <TD align="right"> 0.118 </TD> </TR>
  <TR> <TD align="right"> m2.4xlarge </TD> <TD align="right"> 0.224 </TD> <TD align="right"> 0.236 </TD> <TD align="right"> 0.236 </TD> </TR>
  <TR> <TD align="right"> m3.xlarge </TD> <TD align="right"> 0.092 </TD> <TD align="right"> 0.088 </TD> <TD align="right"> 0.088 </TD> </TR>
  <TR> <TD align="right"> m3.2xlarge </TD> <TD align="right"> 0.183 </TD> <TD align="right"> 0.175 </TD> <TD align="right"> 0.175 </TD> </TR>
  <TR> <TD align="right"> t1.micro </TD> <TD align="right"> 0.004 </TD> <TD align="right"> 0.004 </TD> <TD align="right"> 0.004 </TD> </TR>
  </table>

<figcaption>Lowest observed spot instance prices in dollars in the
regions `us-west-2`, `ap-southeast-1` and
`ap-southeast-2` between 2013-12-08 and 2014-03-09.
</figcaption>

</figure>

These values are in dollars e.g. they are not relative prices. First
of all both `ap-southeast` regions have exactly the same observed
minimum spot prices. The `us-west-2` region has several instances
where prices are identical to `ap-southeast` regions, some where
prices are slightly higher and some slightly lower. However it should
be noted (as can be seen in the earlier graph with relative prices)
these differences are *very small* compared to differences to some
other regions.

Regardless how you slice and dice these numbers I find it exceedingly
unlikely that these very similar relative *and* absolute minimum spot
prices in multiple regions would be result of pure chance. At least
from practical point of view **there are minimum spot prices.**

### How are minimum spot prices set?

If this really is so, it raises another question: **How are these
minimum spot prices determined?** Have they been set by AWS itself, or
are they an artifact of external bidders during the data period?

And if they are set by AWS, then by what policy does AWS set them?

One possibility is that they are calculated from region's on-demand
prices. Yet at least for the three regions considered above this does
not hold. The `ap-southeast` regions have same on-demand prices *but*
`us-west-2` has substantially lower prices. Yet it has very similar
minimum spot prices. For example the `c1.medium` instance type has an
observed minimum spot price of $0.028, yet its price in
`ap-southeast` regions is $0.183 compared to $0.145 in `us-west-2`.

Could the minimum spot prices be based on operational costs? This
seems more plausible since there seems to be similarity in the minimum
prices **between regions for the same instance generation** — that is,
instances running on so-called "first generation" hardware (compared
to "second generation" of
[m3](http://aws.amazon.com/about-aws/whats-new/2012/10/31/announcing-amazon-ec2-m3-instances-and-m1-price-drop/)
and "new generation" of
[c3](http://aws.typepad.com/aws/2013/11/a-generation-of-ec2-instances-for-compute-intensive-workloads.html)
classes) such as `m1`, `c1`, `m2` and `t1`
[had somewhat similar prices](/assets/posts/minimum-spot-price-suspects.svg)
between regions. For `c3` class instance types this similarity is even
more striking:

<figure class="full">
<a href="/assets/posts/minimum-spot-price-2ndgen.svg"><img
src="/assets/posts/minimum-spot-price-2ndgen.svg" alt="minimum
spot prices for c3 instance types"></a>

<figcaption>Minimum spot price for `c3` class instance
types. Different colors correspond to different instance types. Y-axis
positions are slightly jittered. (The reason why you are not seeing
many discs is because most of them are exactly on top of each other.)
`sa-east-1` is missing from this graph as it didn't have
`c3` instance types during the period covered by the data
set.
</figcaption>

</figure>

Note that apart two outliers (more on these below) the relative prices
for `c3` instances between all of the regions are **almost exactly the
same**. Again although *absolute minimum prices differ* the relative
minimums (percentage of the on-demand price) is **almost exactly the
same for almost all regions for almost all `c3` instance types**.

In plain English this means that for all `c3` instance types the
minimum bid price is a fixed percentage of that region's on-demand
instance price.

That'd be a mighty coincidence if there was no minimum and all of this
similarity was result of different bidders all over the world?

Okay. There's the question of the two outliers above: `c3.large` in
`ap-southeast-2` at $0.001 and `c3.8xlarge` in `ap-northeast-1` at
$0.060. Getting `c3.8xlarge` at 1/40 of the on-demand price seems like
a great bargain. If AWS enforced minimum prices I'd expect them to be
set in all regions. Was it left out accidentally for these two cases?
If so, it was around for quite a while (the $0.060 price for
`c3.8xlarge` was hit in 2013-12-10, 2013-12-12, 2014-01-03 and
2014-01-04 for a total of 338 minutes at that price and the $0.001 for
`c3.large` on 16 distinct days between 2013-12-22 and 2014-02-03 for a
total of 13.4 **days**.)

For the outliers I have two explanations:

* **It's an accident.** For some reason the minimum was set
  incorrectly for these two instance types.

* **There is actually no minimum spot price.** Reconciling this view
  with the observed *very similar* minimum relative prices in multiple
  regions is difficult, though. One possibility that comes to mind is
  that maybe — maybe someone itself is bidding in *all spot markets*
  for spare capacity at a *very low price* and these low prices
  reflect those bids when there is *very little demand by other
  customers*.

  Yet even this outlandish scenario raises new questions. Why would
  this hypothetical all-excess-capacity-sucking entity bid at
  *different* prices or even at different *percentages* of on-demand
  prices? Why not bid at absolute $0.001 or at relative 10% in all
  regions for all instance types?  If someone was really doing this
  then it seems reasonable that more than one market would have seen
  such a lull in demand that such a consistent low bid would become
  visible. This hasn't happened (at least not in the data I have).

What else could be gleaned from this data?

* Minimum relative prices for 1st generation instances are more spread
  out than for `c3` instance types. Actually, the `c3` relative prices
  are **very tightly packed**.

  I'm definitely not sure, but this might reflect the underlying
  hardware and its operational costs. I think AWS has learned a lesson
  or two from first generation instances and its hardware. It seems
  reasonable that they have better understanding on how to optimally
  pack instances into a single server and how to operate them.

  The earlier generation instances run on multiple different types of
  hardware (it is know they have different CPU types, at least, see
  [*Is the Same Instance Type Created Equal? Exploiting Heterogeneity of Public Clouds*](http://dx.doi.org/10.1109/TCC.2013.12)
  by Ou, Zhuang et al, 2013) and it seems that the capacity progression
  in `m1`, `m2` and `c1` classes is not always a simple 2x step from
  instance type to another (potentially leaving "unfilled
  gaps"). These might explain why older instance types have more
  "spread" in their relative minimum prices than the newer ones.

* Japan and Europe (`ap-northeast-1` and `eu-west-1`) have
  consistently higher minimum relative spot prices than most other
  regions. OTOH, `ap-southeast-1` is the odd one out since with old
  instance types it had identical relative prices with two other
  regions, but for `c3` instances it stands out as substantially more
  expensive ("less cheap").

  This might be due to relatively higher operational costs in these
  regions *and* that the on-demand prices are *not entirely* based on
  operational costs. That is, they take into account competition,
  willingness of the market to accept the given price level as well as
  any desire by AWS to establish a (dominant?) market presence.  All
  of these may provide a rationale to price on-demand instances at
  relatively lower gross margin level than in other, more established
  regions.

* Also it is interesting that `us-east-1` doesn't stand out as
  "cheaper" for `c3` instances in the same way it did for 1st
  generation instance types.

### Summary

So as a conclusion to the question whether there are minimum spot
prices and who sets them I think the answer is that **from a practical
point of view there are minimum spot prices**. If you are bidding in
these markets you have to understand that there appears to be a
minimum bid price you have to use to have *any* chance of getting an
instance, ever. Although not conclusive, I find the **most plausible**
scenario for these minimum prices that **AWS is setting minimum spot
prices** based on operational costs, but using different formulae for
different instance generations.
