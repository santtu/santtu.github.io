---
layout: post
title: "AWS Service Metadata"
tagline: "<a href='https://github.com/santtu/cloud-meta'>github.com/santtu/cloud-meta</a>"
tags: ["aws"]
---

For about 4–5 days I've been working through AWS's news announcements,
forum posts, digging through history with
[The Wayback Machine](https://archive.org/web/) with the single goal
of sorting out

* when an AWS service became available, and
* how many zones are available at any point in time.

I need this data for the work I'm doing on AWS service availability
([see also here]({%post_url 2014-06-13-aws-service-availability%}))
for the simple reason that any pro-rated availability estimate will be
impossible to calculate useless unless you know for how many
service-hours a given service is actually available. Since not all
services are available in all regions at the same time (or not at all)
and some services expose the underlying availability zone (AZ)
structure I just have to get those values.

Unfortunately there doesn't seem — at least I couldn't find — any
public dataset that contains all of this data in a well-researched
format (or at all, for that matter). With "researched" I mean having a
rationale for each data item in the dataset that can be tracked back
and re-checked from original sources (or archived copies of those) if
needed.

I got the dataset done and since although it is critical in my
research, I really only have need for it once. So I decided to share
it with everybody and put the dataset available under CC BY 4.0
license at
[https://github.com/santtu/cloud-meta](https://github.com/santtu/cloud-meta). I
hope someone will find it useful in their work or research.

Since a blog post without a graph would do, here's a graph showing
number of AWS services, regions and zones from the introduction of
Alexa in 2004 up to a few days ago:

<figure class="full">
<a href="/assets/posts/aws-service-regions-zones.svg"><img
src="/assets/posts/aws-service-regions-zones.svg" alt="aws services,
regions and zones over time"></a>
</figure>

You'll find the original data
[here](https://github.com/santtu/cloud-meta/blob/master/aws/services-state.csv).
