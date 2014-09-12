---
layout: post
title: "What's in your AWS bill?"
tagline: "DevOps Meetup, Helsinki, September 10th 2014"
tags: ["event", "devops", "aws", "cost management"]
---

Two nights ago there was a
[#DevOps meetup](http://www.meetup.com/devops-finland/events/202967592/)
where I had a talk about **AWS cost management**. If you missed the
event ([slides](http://bit.ly/1xNs8dd)) please come to the next
[Helsinki AWS User's Group](http://www.meetup.com/AWS-User-Group-Finland/events/206630362/)
meeting on October 9th where I'm going to do better-and-improved
version of the DevOps talk. (I wasn't entirely happy with my own
presentation, and I'll try to improve it for the next one. Especially
I'll try to avoid
[knitting blankets for destitute devops people](https://twitter.com/ernoaapa/status/509744793870934016).)

Anyway, I wanted to muse on a few observations I made at the
meet. First of all, there were quite a lot of people, over 70 or
so. There's clearly a lot of interest into devops in the Helsinki
area. So during my part, to get a feeling of relevancy and for future
focus I asked the audience a few questions:

1. How many **use** AWS?
2. How many knew their (personal, project's, company's — whatever is
   relevant) **previous** bill's bottom line?
3. How many knew their **current** bill within some reasonable
   accuracy?
4. How many could forecast **current month's** final AWS usage costs?

For these I got about 1) 50%, 2) 20%, 3) 10% and 4) 25% of audience. I
assume that last on was higher than third one because quite many
assumed (knew?) that their AWS bill for the current month would be
zero dollars. I'll rephrase that last one next time differently to get
an idea of how many of those who actually use AWS out of the free tier
are doing cost forecasting.

I find it surprising that so many devops people actively using AWS
apparently were ignorant of their current status as well as AWS
account and billing basics (only a few had seen the monthly PDF
invoice, or knew about consolidated billing). Given that devops
philosophy tries to automate a lot of things, to give a lot of freedom
and responsibility to devops people **and** that any kind of
rapid-turnaround automated deployment to AWS does have potential for
**large cost SNAFUs** it really is a little disconcerting to see so
few people being **even reactive** (minimum risk management) about
their operating costs.

<small>Note: Those who I knew to be from companies with over
$10k/month AWS accounts were quite knowledgeable of these facts. I'm
not sure whether this is cause or effect, though — are they using AWS
because they felt comfortable with it financially, or did that
knowledge come out of necessity when increasing AWS invoicing
attracted attention of their financial controller? Gotta ask
that.</small>

I know that these please-raise-your-hands polls are not statistically
or scientifically robust, so this might just have been a bad
sample. Even if the goal would to have proactive cost management, it
is likely that at least in the beginning only a few people in the team
(those whose neck is the most visible to management) are concerned
about costs. Maybe those people were underrepresented that night.

Perhaps while the benefit of flexibility, elasticity and scale of
cloud services has percolated up organizational chains, the financial
impact of those hasn't. So to get the message straight, for anyone
from management coming here I want to make out two clear statements
for everybody's future benefit:

* There are possibilities for financial surprises when using
  infrastructure cloud services (like AWS). Keep your eyes open.

* There exist mechanisms that can be effectively used to monitor,
  forecast and mitigate these risks, allowing organizations to **use
  the cloud while managing its inherent financial and operational
  risks**. Don't be frightened.

About a year ago I wrote about
[how the cloud changes distribution of risks]({%post_url 2013-07-10-one-viewpoint-on-cloud%}) compared with the "old
way" of acquiring IT services. This is exactly the same thing. Risks
previously implicitly "outsourced" are now explicit, and by
recognizing them as such they do become manageable.

<br/>
<br/>

Oh, last but not least. I did not catch a single person admitting they
are using AWS spot instances. Frankly I wasn't excepting many — but
really, zero?
