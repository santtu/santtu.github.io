---
layout: post
title: "m1 marching into obsolescence?"
tagline: "Retiring instance types - revisited"
tags: ["aws", "ec2"]
excerpt: false
---

> I'm revisiting the topic of my earlier post [retiring instance
> types]({% post_url 2014-01-13-aws-retiring-instance-types %}) from a
> couple months back. You might want to check it out first. It has
> more pictures than this post.

Ars technica wrote about [Intel's "Powered by Intel Cloud
Technology"](http://arstechnica.com/information-technology/2014/01/intel-inside-shifts-from-pcs-to-virtual-machines-in-the-cloud/)
just two days after my previous AWS post. I couldn't find a date when
[this branding
program](http://www.intelcloudfinder.com/intelcloudtechnology) was
launched, but the Ars post was the earliest I could find (Intel's blog
has a post from [January
15th](https://communities.intel.com/community/itpeernetwork/datastack/blog/2014/01/15/looking-for-the-right-cloud-technology-look-for-the-new-intel-badge))
so I'm assuming this really was announced in January.

It is clear that AWS and Intel have been working together on this
programme for a longer time. It is telling that no AWS announcement
[on year 2012](http://aws.amazon.com/about-aws/whats-new/2012/) is
more explicit about processor type than "Intel Xeon", no announcement
[from year 2011](http://aws.amazon.com/about-aws/whats-new/2011/)
mentions processor type at all but [year
2013](http://aws.amazon.com/about-aws/whats-new/2013/) starts right
off the bat with the announcement of the [cr1 instance
class](http://aws.amazon.com/about-aws/whats-new/2013/01/21/announcing-high-mem-cluster-instances-for-amazon-ec2/)
giving a full lowdown on its processor specs.

There was an Intel PR announcement on [September 10th
2013](http://newsroom.intel.com/community/intel_newsroom/blog/2013/09/10/intel-introduces-highly-versatile-datacenter-processor-family-architected-for-new-era-of-services)
about AWS's use of Intel processors but **that story** does not
contain reference to the "Powered by Intel Cloud Technology"
program. So something was brewing already in September 2013 but it
wasn't yet given a name …

> So it seems that the reason behind AWS becoming more explicit about
  the underlying processor hardware is due to its relationships with
  Intel and the "Powered by Intel Cloud Technology" program. I just
  wonder what kind of benefits this program gives AWS — and as [Ars
  points
  out](http://arstechnica.com/information-technology/2014/01/intel-inside-shifts-from-pcs-to-virtual-machines-in-the-cloud/),
  why neither Compute Engine or Windows Azure partake in the program?

If you trawl the Internet archives you'll also find that AWS **did
not** specify m3's processor type when they were [first
announced](http://aws.amazon.com/about-aws/whats-new/2012/10/31/announcing-amazon-ec2-m3-instances-and-m1-price-drop/). The
exact processor type was added to EC2 instance description sometime
between [September 1st
2013](http://web.archive.org/web/20130901044833/https://aws.amazon.com/ec2/instance-types/)
and [September 9th
2013](http://web.archive.org/web/20130909200405/http://aws.amazon.com/ec2/instance-types/).

Okay but how does this buhaha about "Intel Inside" and m3 have to do with m1?

AWS has given a lot of screen estate telling its customers how m3
instance types are cheaper and better and shinier than the old
first-generation m1 instances. For example, see the announcement on
[m3.medium and m3.large
types](http://aws.amazon.com/about-aws/whats-new/2014/01/21/announcing-new-amazon-ec2-m3-instance-sizes-and-lower-prices-for-amazon-s3-and-amazon-ebs/)
and [availability of m3 RDS
instances](http://aws.amazon.com/about-aws/whats-new/2014/02/20/amazon-rds-now-offers-new-faster-and-cheaper-db-instances/)
for a few choice words. Alternatively hear what AWS's chief
evangelist, [Jeff Barr
says](http://aws.typepad.com/aws/2014/02/amazon-rds-support-for-second-generation-standard-instances.html):
*"You get significantly higher and more consistent compute power at a
lower price when you use these instances"*. Or *"compared to M1
instances, M3 instances provide better, more consistent perfromance at
lower prices"* on the [EC2 instance description page
itself](http://aws.amazon.com/ec2/instance-types/).

For me this seems like less-than-subtle prodding for AWS customers to
move away from m1 EC2 and RDS instance types. But why? Moving your
customers to a **cheaper** platform makes no business sense **unless
it generates more revenue** than is lost due to lower pricing. How
could this be true? A couple of possibilities exist:

1. New instance classes are cheaper to purchase and/or operate (cheap
   enough to give better operating profit than old instances). Note
   that the newer instance types fall under Intel's cloud technology
   program whereas old ones do not.

2. There is a desire to obsolete old instance class for some **other**
   reason than operating profit alone. (Maybe AWS wants those racks
   freed for other uses?)

Following the business logic of the first case will still eventually
lead to obsoletion of old instance class **hardware**. Whether it will
lead to obsoletion of the instance **class** is another thing
entirely. Yet it is hard to see how the "old" m1 instance class could
be kept interesting to customers without reducing its price. But why
do that? The only reason would be to squeeze the last cents out of
EOL'ed class.

<small>(Of course AWS has the **spot market** to peddle those less
desirable instance types at so-called "market rates" … More on the
spot market later.)</small>

Now for the practical advise section! Now after m3.medium was
announced it is clear that you should:

* **Use m3.medium instead of m1.medium.**
* **Use m3.large instead of m1.large.**
* **Use m3.xlarge instead of m1.xlarge.**

If you are using any other m1 type than m1.small you really really
should go and evaluate m3 class instances instead. They offer better
performance at lower cost. (Just don't do it blindly. Test
first. Never assume anything with instances. Trust your own numbers,
not others'.)

Which makes me ponder, what of m1.small? I earlier argued that
m1.small fills an important sweet price spot between t1.micro and the
next type up the line (at that time either m1.large or c1.medium, now
to m3.medium). This still applies. There is **no** m3.small.

At least not yet.

I wonder.
