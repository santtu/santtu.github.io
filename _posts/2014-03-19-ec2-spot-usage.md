---
layout: post
title: "Using spot instances"
tagline: ""
tags: ["aws", "ec2", "spot instances"]
---

(You might want first see the [introduction to this series of
posts]({% post_url 2014-03-12-ec2-spot-intro %}) if you jumped in here
randomly.)

## <a name="si-howto"></a>How to use spot instances

I'm going through a couple of topics related on *how to use spot
instances*:

* Suitable applications and workloads for spot instances
* Bidding automation and bidding strategies
* Minimizing effects of price spikes

Determining whether your application can benefit from cost savings
using spot instance is quite straightforward to analyze — it's a cost
vs. cost analysis. There is quite a lot of information on bidding
strategies and cost spike mitigation, but information in bidding
automation is sparse as companies using spot instances generally do
not publish their bidding engines or its parameters.

### Suitable applications and workloads

Here's a list of applications suitable for spot instances [according
to the source
itself](http://www.slideshare.net/AmazonWebServices/optimizing-your-infrastructure-costs-on-aws/22):

* Batch processing
* Hadoop
* Scientific computing
* Video and image processing and rendering
* Web / Data crawling
* Financial (analytics)
* HPC
* Cheap compute ("backend servers for facebook games")
* Testing

The common theme in all of these is **loss of an instance is not a
catastrophe**. You can influence the likelihood of an instance loss
through the bid price (see [instance availability]({% post_url 2014-03-12-ec2-spot-instances %}#si-spot-availability) in previous
post), but unless you are willing to face potentially [absurd
costs]({% post_url 2014-03-12-ec2-spot-instances %}#si-spot-999-dollars) to guarantee 100% spot instance availability
you'll have to come to face with the fact that:

**You have to be able to recover from sudden spot instance
termination.**

Whether you would want to use spot instances and whether you can use
spot instances is determined by three factors:

1. Potential savings gained by using spot instances.
2. Costs of a spot instance failure. For example loss of profit and
   money and work required to recover.
3. Costs required to either completely avoid failure in face of spot
   instance failures, or to mitigate the risk to acceptable levels.

The firsts two are recurring (you get savings continuously, but spot
instance failures also occur continuously) whereas the third one is
mostly one-off cost.

And face it, if you are using spot instances you have to be prepared
that **many of them fail at the same time**. You can have some
influence over the number of lost instances by using multiple
availability zones and tiered bidding (see
[moz.com developer blog for excellent insights](http://devblog.moz.com/2011/09/amazon-ec2-spot-request-volatility-hits-1000hour/))
but however you slice and dice you still come to the fact that:

**You have to be able to recover from sudden spot instance
termination.**

**How** you deal with instance termination is affected by what are
your costs to fail and costs to prevent failure. Consider a few cases:

* **Spot instances as build slaves.** Your CI automatically provisions
  build slaves from spot market as needed (and tears them down when
  demand goes down). So now suddenly all your build slaves went away —
  so what? Jobs failed, builds lost, but it's not going to kill your
  devtest.

  The recovery method in this case would be simple: first of all, the
  CI instance launcher might already have built-in balancing from many
  zones (meaning it'll bid in multiple availability zones). Even if
  that wasn't the case you could go and manually change the bidding
  parameters to a higher bid price (maybe you accept a bit higher
  costs while thinking of some other solution), use another zone or
  use another instance type. You might equally well just wait a while
  to see if the price just spiked and would go down soon.

  In this case it is likely that the cost to prevent interruption of
  CI jobs would be higher than productivity losses so it is reasonable
  just to wait it out and handle any aftermath manually.

  (Just do not run your build master in a spot instance.)

* **Hadoop cluster.** Assuming you are using your Hadoop cluster
  semi-continuously (ground radar signal processing, mobile game user
  analysis etc.) there are a few possible scenarios. For the most part
  Hadoop will automatically re-assign map-reduce jobs from failed
  nodes, so loss of some nodes isn't a biggie for Hadoop at
  all. Mahujar's post [Riding the Spotted
  Elephant](http://www.qubole.com/riding-the-spotted-elephant/) is an
  excellent article discussing various pros and cons on different ways
  to use spot instances with Hadoop. Essentially this boils down to:

  It is possible to run a Hadoop cluster using spot instances where
  sudden price peaks will have only a limited effect (delaying
  completion of some jobs) sans *force majeure* situations.

  In this case you could be hedging your bets by using a hybrid
  cluster, some on-demand instances and some spot instances,
  potentially with tiered bidding. This will increase the running cost
  but will be highly likely to prevent massive failures.

* **Financial analysis.** (I'm not a financial market wiz, so bear
  with my unbelievable scenario here, please.) You're running a
  financial modeling job nightly using spot instances. The job will
  take 4 hours to complete and the time window to run it is six
  hours. It **must not fail**.

  Okay, if it must not fail then you should **not** be running it
  using spot instances in the first place. So let's reword the
  requirement. "Must not fail with nightly operating costs less than
  X." That is, if the cost of *not failing* would be over X you can
  fail.

  You'll need three things: bidding automation, provisioning
  automation and checkpointing. The first one is to try to keep your
  instances alive as much as feasible. The second one is to try to
  acquire complementary resources (on-demand instances, other types of
  spot instances, another region — whatever it takes) in case you
  start losing spot instances and the third one is to ensure that when
  you get replacement instances you can quickly continue from where
  the analysis stopped without having to re-do everything from
  scratch.

  In this case the cost of prevention is large — setting up the
  required automation *and testing it to death* will itself require a
  large effort, not to speak about the costs that will come *after the
  automation kicks in*. But then again, the failure to run to
  completion would be expensive too.

**The less time-critical and more resilient your computing
requirements are the easier it is to move them over to use spot
instances.**

> If you are using AWS in a large scale then you should already have
> disaster recovery plans for situations that would affect your
> service such as a whole availability zone going out (or a whole
> region in case you are
> [Netflix](http://techblog.netflix.com/2011/04/lessons-netflix-learned-from-aws-outage.html)). When
> using spot instances you'll need to factor in plans for *persistent
> spot price increases*. If spot prices go up, for how long are you
> willing to "wait it out" to see if they drop back down? What will
> you then do when you decide they're not coming down?

To recap:

* Don't use spot instances if your requirements include "must not fail"
* Do a cost-benefit analysis:
    * Estimate savings
    * Estimate cost of failure
    * Estimate cost of avoiding failure
	* Compare

### Bidding automation and bidding strategies

> If you are using spot instances now and then for one-off tests you
> should do bidding manually. In this case you should bid higher than
> the current market price (see what I wrote about
> [instance availability]({% post_url 2014-03-12-ec2-spot-instances %}#si-spot-availability) in previous post) to prevent small price
> fluctuations from terminating your instance. Just remember — don't
> bid higher than you are willing to pay!

For simple use cases a using auto scaling for provisioning automation
and setting the spot instance bid price (in auto scale launch
configuration) is sufficient. This can't alone guarantee availability
of a service, but it will be enough for less than 24/7 operations.

If you had provisioning automation (automatic scale-up and scale-down)
before then adding spot instances brings in a few complications:

* Launching spot instances takes a longer time than on-demand
  instances (bidding process itself takes extra time).

* Spot market price <strike>can</strike> will vary over time,
  including potentially large spikes. You have to decide how to deal
  with spikes.

* Your spot instances can all just *vanish* with a sudden spot price
  spike.

Writing a spot market bidding and provisioning engine is thus more
complicated than for scaling up and down with on-demand
instances. **Do make sure** that you put in hard limits to your bid
prices. Remember the poor sod who paid $999.99/hour for his/her spot
instances.

#### Strategies

Depending on your application requirements you can apply several
different provisioning and bidding
strategies. [Here's a video](http://www.youtube.com/watch?v=WD9N73F3Fao)
that discusses various strategies AWS has detected its customers
using:

1. **Optimizing costs.** These customers bid at reserved instance
   pricing level with the goal of gaining RI-level costs without their
   up-front costs. Needless to say, bidding at this low level you are
   facing loss of all spot instances during a price hike.

2. **Optimizing costs and availability.** These bid at a level between
   reserved instance price and on-demand instance price. This will not
   protect from sudden price hikes, but will prevent smaller
   fluctuations from terminating instances.

3. **Capable of switching to on-demand instances.** These customers
   have provisioning automation that can automatically shift from
   bidding for spot instances to provisioning on-demand instances when
   it detects that spot prices have increased >1x price level. These
   typically bid at on-demand price level or a little higher.

4. **High bidders for availability.** For these they are interested in
   getting **average** savings from spot instances, but put a large
   value on availability of their spot instances. These will bid
   significantly higher than on-demand price.

   I think this is a reasonable strategy to deploy interrupt-sensitive
   application using spot instances **with the caveat** that you must
   be able to later move to cheaper resources (on-demand instances,
   reserved instances, other zones, other instance types, other
   regions) without service interruption. If you cannot move over,
   then permanently bidding high in hope of getting **both** savings
   **and** availability is gambling, not a strategy.

5. **High bidders for resources.** There's another reason to bid
   high. At
   [4:00 in the video](http://www.youtube.com/watch?v=WD9N73F3Fao#t=239)
   there's a description about BrowserMob's provisioning strategy
   where they put a very high value in getting the resources they
   need. When BrowserMob's system determines it needs more capacity,
   it'll first bid at spot market (the video doesn't say but I'd guess
   at on-demand price). If it can't get resources from the spot
   market, it'll try to acquire an on-demand instance. If that fails,
   it'll start bidding in the spot market at a high level.

Note that bidding high is a workable strategy only as long as most
**don't** bid high.

#### <a name="si-spot-over-bidding"></a>Bidding over the on-demand price

I want to emphasize the following:

Contrary to a lot of comments in the Internet **bidding over on-demand
price is an entirely rational bidding strategy** in certain
cases. Consider the two graphs below:

<figure class="full">
<a href="/assets/posts/spot-price-us-west-1-c1-xlarge.svg"><img class="double" src="/assets/posts/spot-price-us-west-1-c1-xlarge.svg" alt="c1.xlarge spot price medium volatility across zones in us-east-1"></a>
<a href="/assets/posts/spot-availability-cost-us-west-1-c1-xlarge.svg"><img class="double" src="/assets/posts/spot-availability-cost-us-west-1-c1-xlarge.svg" alt="c1.xlarge cost at availability in us-west-1"></a>

<figcaption><code>c1.xlarge</code> in <code>us-west-1</code>. Left
graph shows market price where solid line is daily average and lightly
colored boxes are the daily maximum price. Right graph shows what
would have been the total cost to achieve certain availability
target. The light vertical bar is 1/4x on-demand price.
</figcaption>

</figure>

The table below shows what you would have had to bid (again, this is
*post hoc* analysis, you would not have been able to know these values
beforehand) to gain 100% availability *and* what it would have **cost
you** had you bid at the given level.

<figure>
<table>
<thead><tr><th>Zone</th><th>Relative Bid Price</th><th>Relative Cost</th><th>Availability</th></tr></thead>
<tbody>
<tr>
<td>Zone 1</td>
<td>1.293</td>
<td>0.201</td>
<td>100%</td>
</tr>
<tr>
<td>Zone 2</td>
<td>17.241</td>
<td>0.267</td>
<td>100%</td>
</tr>
<tr>
<td>Zone 3</td>
<td>17.241</td>
<td>0.193</td>
<td>100%</td>
</tr>
</tbody>
</table>

<figcaption>
Bid prices and total costs relative to on-demand prices for
<code>c1.xlarge</code> instances in <code>us-west-1</code> over the
same time period as with earlier graphs. The cheapest zone ended being
zone 3 with the required bid being >17× on-demand instance price. Yet
the zone with the lowest maximum bid price (zone 1) ended up being more
4% more expensive than zone 3.
</figcaption>
</figure>

I think this make it clear that **bidding over the on-demand price can
be entirely sensible strategy** in some cases. It just isn't a
strategy you should be doing blindly. If you can't handle
interruptions nor you can move your workload to other zones, other
spot instance types, or on-demand instances and are bidding high, then
you are in a very, very bad place when the price goes up for an
extended period of time.

To summarize the last point: unless you have good automation that can
shift your workload seamlessly from high-priced spot instances then
you should stick to one of the three first bidding strategies. They at
least have a known failure model (e.g. you lose instances).

### Minimizing effects of price volatility

Since spot price volatility is a given, is it then possible to somehow
control the effects of that volatility? The basic approach is to
reduce the probability of that volatility causing problems and
secondarily to limit the impact of any problems encountered.

#### Tiered bidding and multiple zones

There are few other tricks noted elsewhere that you can use to
restrict the severity of price hikes:

* Bid in multiple tiers. Add some randomness to your spot bids. If you
  determine that you should bid your resources at X, then bid at X,
  X + 5%, X + 10% and X + 15%. This means that if the spot price peaks
  at X + 4% then you'd lose only 3/4 of your spot instances. (You can
  elaborate this further and match the bidding structure to some
  "reasonable" estimates of price volatility based on history
  etc. etc.)

* Bid in multiple availability zones, but in different bids. Don't
  blindly use the AWS's behavior of picking the cheapest zone when you
  specify multiple zones in a bid. If you have bid automation, don't
  blindly always bid in the "cheapest" zone either.

* If your application can automatically handle new instances
  (self-registration, autodiscovery etc.), you can live short price
  spikes through with *persistent bids*. Persistent bids stay in the
  bidding pool and will be filled at any time the spot price is below
  the bid price — even if the bid "lost" its instances due to a price
  spike.

AWS allows you to specify multiple availability zones in a single
bid. In this case AWS will pick the cheapest (lowest spot price) zone
*at that moment* where the spot request can be fulfilled.

If you continuously put your instances into the cheapest zone **the
majority of your instances are likely to end up in a single
availability zone**. Take a loot at the graph below showing `m1.small`
spot prices in multiple availability zones. There is always a
possibility that a single zone has a long stretch of relative
tranquility and low prices.

<figure>
<a href="/assets/posts/zones-spot-price-us-east-1-m1-small.svg"><img
src="/assets/posts/zones-spot-price-us-east-1-m1-small.svg"
alt="m1.small instance prices in us-east-1"></a>

<figcaption><code>m1.small</code> in <code>us-east-1</code>. Notice
how zones 1, 2 and 4 have a long history of low prices and low
volatility, yet zones 2 and 4 have sudden spot price level changes.
</figcaption>

</figure>

Yet that tranquility can always end suddenly. I haven't looked at time
correlations between zone prices, but from a look at the graphs I
think there is sometimes correlation (e.g. if spot price raises in a
zone for an instance type it is likely to go up in another zone), but
similarly sometimes there is no such correlation.

So you should ensure that your spot instance bids are distributed over
multiple availability zones if that is feasible for your
application. See [Bryce Howard's](http://moz.com/blog/crawl-outage)
commentary on moz.com crawler outage and how it was primarily caused
by placing spot instances in a single availability zone.

#### Hybrid

A very common advice is to
[not run all your infrastructure on spot instances](http://gigaom.com/2011/12/27/how-to-deal-with-amazons-spot-server-price-spikes/). This
is a very good advice. It is not always sensible to go after the
highest savings. A good strategy is to use a healthy mix of reserved
instances, on-demand instances and spot instances.

#### Keeping state, checkpointing, job subdivision

This is a topic I'm not going to go deeply, but the core idea is
simple:

* Periodically save the state of whatever your spot instance is doing
  (checkpointing) so that if it is terminated, another instance can
  continue from the last saved checkpoint.

Extension of this is to store the state continuously, but there are
tons of tradeoff and what's a good choice depends on your goals and
your applications. Computation tasks that split naturally into
iterations or queueable jobs are easy, those that have gigabytes of
state or require a lot of I/O to store temporary results are more
difficult.

Keep in mind that AWS will **not charge for a partial hour on spot
instances it terminates**. This means that you should consider
checkpointing only for long-running jobs and those where job
completion time is an important factor. If your jobs take less than an
hour then a loss of a spot instance will only delay the job, but that
delay won't cost you anything in instance charges either.

(You can
[play chicken with spot instances](http://shlomoswidler.com/2011/02/play-chicken-with-spot-instances.html)
where after you're done with the instance you won't actually terminate
it immediately, but wait to see if AWS does it before the full
hour. Sometimes this gives you the instance-hour for free…)

There is some research into checkpointing and spot instances. See for
example
[Monetary Cost-Aware Checkpointing and Migration on Amazon Cloud Spot Instances](http://dx.doi.org/10.1109/TSC.2011.44)
(Yi, Andrzejak and Kondo, 2012) and
[Reliable Provisioning of Spot Instances for Compute-intensive Applications](http://dx.doi.org/10.1109/AINA.2012.106)
(Voorsluys and Buyya, 2012). I'm not myself aware of systems that use
heavy-handed state checkpointing.  There are quite a few that use spot
instances as worker nodes (with <1hour jobs) where the real difficulty
boils more into detecting failures and tuning retry timeouts than
bothering with any form of checkpointing.

### Commentary

It is relatively easy to understand the behavior of spot instances *in
itself* — *Bid < Price ⇒ Terminate*. The difficulty of using spot
instances lies in the fact that it is a market (at least that's what
we're led to believe) driven by supply and demand and a lot of
*mostly* rational bidders.

We can know how our spot instances behave when the spot market price
changes. But **we cannot predict the spot market itself**.

This means that although you can influence the likelihood of spot
instance termination through bidding strategy, **you still have to be
able to recover from sudden (and massive) spot instance termination.**

Did I get *that* through?

### Further reading

* Jenkins [AWS EC2
  Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Amazon+EC2+Plugin)
  has spot instance support since version 1.19. Caveat emptor: I
  haven't used it with spot instances (on-demand only).
* That said, I know companies which prefer the [Swarm
  plugin](https://wiki.jenkins-ci.org/display/JENKINS/Swarm+Plugin)
  for node discovery and use custom provisioning scripts. That's a
  roll-your-own path for bidding and provisioning automation, though.
* See [Tapjoy's
  slides](http://www.slideshare.net/AmazonWebServices/reinventing-your-innovation-cycle-by-scaling-out-with-spot-instances-cpn207-aws-reinvent-2013)
  on how they're using Jenkins with spot instances.
* AWS's [Continuous Deployment Practices, with Production, Test and
  Development Environments Running on
  AWS](http://www.slideshare.net/amazonwebservices/continuous-deploymentpractices)
  set talks about a lot more than spot instances, but see [slide
  49](http://www.slideshare.net/amazonwebservices/continuous-deploymentpractices/49)
  about where to use spot instances vs. other instance types in a more
  complex CI environment.
* [EC2 Performance, Spot Instance ROI and EMR
  Scalability](http://www.jesse-anderson.com/2012/02/ec2-performance-spot-instance-roi-and-emr-scalability/)
  by Jesse Anderson covers a lot about determining correct instance
  types his project, but covers also using spot instances.
* [Using Spot Instances in Amazon EMR without the risk of losing the
  job](http://understandbigdata.wordpress.com/2012/12/26/using-spot-instances-in-amazon-emr-without-the-risk-of-losing-the-job/)
  has concrete examples on how to use EMR via command line with spot
  instances.
* [See Spot Run: Using Spot Instances for MapReduce
  Workflows](https://www.usenix.org/legacy/event/hotcloud10/tech/full_papers/Chohan.pdf)
  (Chohan et al, 2010) is a good read. It also notes that under some
  conditions adding spot instances (that will be terminated) actually
  increases Hadoop job completion time and its total cost.

Here's the [next post in the series]({% post_url 2014-03-20-ec2-spot-market %}).
