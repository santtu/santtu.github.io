---
layout: post
title: "One viewpoint on cloud computing"
tagline: "Why did initially startups embrace it and enterprises fail to take notice?"
tags: ["cloud computing", "cloud", "amazon web services", "aws", "startups"]
---

Recently I was consulting a client on cloud strategy. When we were
trying to explain to the client how the risk landscape with growing
adoption of cloud computing (being the case that it affects them even
if they don't themselves use cloud services) ... I had an idea.

An idea that I think gives some insight why enterprises and especially
IT companies were slow on cloud uptake and why small and agile
startups were quick to take up on it.

Before I get to the actual idea, I need to go through some background
information first. If you're super duper familiar with risk management
in IT service procurement, feel free to skip ahead.

Bloody long introduction
------------------------

So, you know what risk is?
[Wikipedia](https://en.wikipedia.org/wiki/Risk#Quantitative_analysis)
puts it this eloquently:

    risk = probability × loss

That is if you have a 0.5% yearly probability event that costs you
$1M, and another with 50% probability and a loss of $10,000 these are
crudely equal with expected yearly losses of $5,000 for **both**. So
you'll take both the probability of a bad thing happening and the
consequences of that thing happening **together** as a risk.

> Caveat emptor: This is only one viewpoint on risk.

This view of risks comes with an attached, implicit viewpoint. It is
viewed as **my** risk. For example, the risk to me of **your** house
catching fire is neglible (being non-neglible only if you happen to
live within 100 meters), because the **loss to me** of your house
burning is zero → my risk is zero too.

In larger businesses and government agencies it is common to push
enterprise's risk ("my") risk to the vendor ("your risk") through
contractual means. In areas of IT service procurement this means the
service provider assumes liabilities on not meeting service level
agreements / deviating from rules and regulations / other failures. In
exchange to .. well, of course, higher fees.

So, the risk **probability** can be divided into two components:
**mine** and **yours**.

The service provider may mitigate its risks by many means. It might
employ quality process models and employ good quality hardware as well
as cover residual risks with insurances, for example. (More cynically
oriented might expect the vendor to not do so.)

Anyway this does provide two more aspects to consider when
understanding the **loss** component. For this discussion I'll split
it into **methods** and **means**. Processes and hardware, if you
like.

So we get to:

    risk coverage = (me ⇆ you) × (methods ⇆ means)

Ignore the pseudo-scientific notation for a minute. What I mean here is:

* ``(me ⇆ you)``  

  You can push risk probability to someone else, or handle it
  yourself.  Not surprisingly corporate and governmental organizations
  tend to push risks away from themselves. After all it is easier to
  say *"We had a contract with ACME Corp. to cover all bases! They
  fucked up!"* than to *"It was our fault."*  

  You can always count on people in large entities to *cover their
  asses* without regard to global optimum - it's not their money,
  after all.

* Methods and means relate .. here's an example.  

  One network security risk aspect is the management of firewalls. To
  have good security you need to have good processes to ensure that
  only the minimum set of required holes are used, knowledge to
  understand the security model, an audit trail of changes, and so on.

  Good processes don't mean anything without some means to turn those
  processes into the desired action. In this example that would
  require an actual network firewall (hardware). You can wish and
  design and change manage all you want but without a firewall those
  policies would have zero effect (e.g. you'd have no network
  security, or alternatively no network, both of which would be bad
  for business).

Finally we are getting close to the **cloud**. So bear with me.

The "traditional" way to manage IT service risks was to let the
service vendor handle the risk. The risk coverage model was a bit like
below (with dashes on non-relevant things):

    my risk coverage =   (me ⇆ ---) × (------- ⇆ -----)
    your risk coverage = (-- ⇆ you) × (methods ⇆ means)

<small>(Note: I'm not sure whether the word "coverage" is a good
choice here. Can't figure out anything better, though...)</small>

When shit then did hit the fan it was **you** (the vendor) that had to
handle bad publicity and the resulting loss of income (sanctions,
paybacks etc.). There are some risks that cannot be transferred
(opportunity costs etc.), but generally my losses would be small-ish.

<small>(There is a bank in Finland which has an IT service vendor
handle its computing needs. All the standard high quality goodies: hot
standby fail-over data center with redundant connectivity between the
two. The link was so redundant and reliable that when one of the
redundant links actually did **fail**, it reliably caused the other
link to **fail** at the same time. This kind of mind-blowing
cluster-fuckup cost the service vendor, but cost the bank probably
quite a lot too. Small-ISH is relative.)</small>

With the introduction of **cloud computing** and its commodity
computing model the the coverage handling of risks has changed:

    my risk coverage   = (me ⇆ ---) × (methods ⇆ -----)
    your risk coverage = (-- ⇆ you) × (------- ⇆ means)

Now a cloud computing provider's job is to provide the **technical**
services I have purchased at an agreed SLA. However the cloud vendor
**does not** take the responsibility to ensure that I would use its
services either correctly or effectively! In a cloud computing
environment **I must now handle processes** that make effective use of
the means provided by the cloud vendor.

Going back to the firewall example with [Amazon Web
Services](http://aws.amazon.com):

* AWS is liable if it fails to either a) provide the firewall services
  (security groups, VPC network ACLs) with agreed availability or b)
  they have other functional problems (like passing traffic not
  explciitly allowed).

* AWS **is not** liable if **I do "allow all from all"** and someone
  hacks the system when I didn't do the methods bit properly. I have
  to understand and implement the methods to use the means AWS
  provides to meet my own business goals.

Finally, a point
----------------

Out of this comes the synthesis of the great idea I referred earlier:

> The introduction of cloud computing doesn't substantially change IT
> service risks, but it does change the distribution of these risks
> between the client and the service provider.

What's so **bloody difficult** in this for many enterprise and
governmental clients is that **for years they have oursourced all IT
risk management processes and now they would have to learn to handle
it themselves** (or find someone else to do that — a market that
didn't exist when cloud computing came around).

Alternatively said:

> Earlier, the negotiation of distribution of risk between clients and
  service providers was a business negotiation, an exchange of
  responsibilities and liabilities versus fees required to accept
  those responsibilities and liabilities.

> Cloud computing in contrast is a **commodity** market where the
  service provider tries to minimize negotiations with the clients by
  providing a limited set of contract options for its clients.

<a name="startups"></a>So WTBF about startups?
-----------------------

Well think about it.

### 10 years ago

You're a startup. You need IT service. You go to a IT provider. You
are so bloody small, they give you a crap deal. You can't negotiate —
it's either their way, or the highway. You call some other vendors,
but in the end you're really negotiating just different shades of
blue. So you sign.

Then they blow up. You go out of business. (The contract? Yeah, good
luck in trying. Even if you win, their standard contract you had to
accept doesn't give you back the business you lost. Remember, you're a
startup, you don't have the capital to survive someone else's
fuck-up. Your house was next to my tinderbox.)

### When cloud computing comes around

You're a startup. You need IT service. You go to a cloud
provider. They give you just one deal, the same deal everybody
gets. You can't negotiate — it's either the cloud way, or get a TARDIS
and go back 10 years (previous chapter).

(Then they blow up. Same situation as 10 years back, minus the
lawyer.)

So ...

Startups have never ever had the chance to negotiate risks on the same
level as enterprises. Earlier they had to take the crap
deal. (Alternatively they had to live in the shadows of the "real" IT
economy, that is, hugging servers and trying to negotiate a reasonable
deal with ISPs to get fat enough Internet pipe and worry the hair gray
about their cheap hardware and colo deals.)

When cloud computing came around it offered **no worse** risk
distribution than startups ever had to handle, yet it offered **new
capabilities** that the earlier model lacked.

No wonder startups embraced the cloud. Even with an unknown future,
the cloud was guaranteed to be **no worse** than what was available
before.

Afterword
---------

This is just one viewpoint. Making an assumption that this would be
the **only** reason for success and fast adoption of cloud computing
in startups is both wrong and retrofitting the facts to a fabricated
historical narrative. Don't fall for that. Reality is much, much more
complex.
