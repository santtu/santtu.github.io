---
title: "Watts, watts, watts!"
tagline: "Energy labeling for web sites?"
tags: ["energy efficiency"]
---

A few days ago I read this tweet from Nicholas Weaver about laptop
fans spinning on a certain web site.

<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet tw-align-center" lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/ncweaver">@ncweaver</a> <a href="https://twitter.com/mikko">@mikko</a> How about energy labels for websites? Forbes clearly a D.</p>&mdash; Santeri Paavolainen (@paavolainen) <a href="https://twitter.com/paavolainen/status/610782782965555200">June 16, 2015</a>
</blockquote>

It was sort of a joke. Think
[European Union energy labeling](https://en.wikipedia.org/?title=European_Union_energy_label). Would
a random site get an A++ or a D energy efficiency label? Based on
what? What a thought!

But as things go, that thought would not leave me alone. There
**clearly** are some applications that routinely will busyloop on a
cpu core[^1]. As Nicholas said, there are also some web sites that put
a large burden on the processor, too. You can literally feel that as
[**heat on your lap**](https://en.wikipedia.org/wiki/Laptop_cooler).

## How much?

The question is **how much power can a power-hungry website consume?**

<div style="text-align: center; padding: 1em; line-height: 1.2em; font-size: x-large;">
I am ready. I have a pluggable power meter, computer, paper and
a pen.
</div>

So I set up to work. First I measured[^methods] some baseline power usage levels
on my laptop[^laptop] with different screen brightness levels:

<figure>
<a href="/assets/posts/website-power-baseline.svg"><img
src="/assets/posts/website-power-baseline.svg" alt="baseline power usage graphs"></a>
<figcaption>From left to right: lowest visible brightness level, screen off, 50% brightness, 50% brightness with browser running and 100% screen brightness.
</figcaption>
</figure>

I decided to use 50% screen brightness for my tests. Notice that the
difference between screen off and lowest brightness level seems
neglible, which is interesting. I had expected that the backlight
would consume significantly more power than screen completely
off. (The measurement baseline of screen at 50% intensity with Google
Chrome running and a single incognito window open used 10.8 ± 0.7 W.)

Having set up the baseline, time to browse some sites! After gathering
data on several randomly chosen sites I divided sites into three
groups, **low**, **medium** and **high** power usage:

<figure>
<a href="/assets/posts/website-power-measurements.svg"><img
src="/assets/posts/website-power-measurements.svg" alt="power usage graphs"></a>
<figcaption>From left to right, in low power group: [New Scientist](http://www.newscientist.com), [BBC](http://www.bbc.com), [Apple](http://www.apple.com), [YouTube](http://www.youtube.com), [Google](http://www.google.com); in medium power group: [Vimeo](http://vimeo.com) playing a video, YouTube video in fullscreen mode, Vimeo video in fullscreen mode, [The Guardian](http://www.theguardian.com), YouTube video; in high power group: [The New York Times](http://www.nytimes.com).
</figcaption>
</figure>

Power usage by group was

* Low power group: 10.7 ± 0.9 W
* Medium power group: 20 ± 3 W
* High power group: 48 ± 3 W

Considering Nicholas's comment I was surprised about Forbes being in
the low power group. One factor might have been that I have the Flash
plugin disabled by default, and there was at least one Flash ad on the
Forbes front page. Secondly, I was expecting a more uniform power use
distribution, but at least these results were quite stratified. I was
also expecting that video sites would be the most power hungry. They
weren't.

The main conclusion based on this very limited sampling is nonetheless
clear: **there are significant differences in browser power use
between web sites**. The difference between low and medium group is
almost 10 watts and grows to **almost 50 watts** between low power
group and The New York Times site.

## Post Scriptum: Does that matter?

The global electricity consumption[^4] is about 2 **terawatts**. Even
if we assume that **30% of world population use 1 hour a day browsing
the web** then 10 watts more power would mean a total of 875 megawatts
more power consumed, which is only 440 parts per million of the global
electricity consumption.

So is 875 MW a large number or not? Perhaps it is better to compare it
against **power conservation efforts**. Let's take the European Union
energy labels for refridgerators as a reference. When the labels were
introduced the lowest energy label was an A. Now it is A+++ whose
difference is 33 kWh per annum[^5]. This difference multiplied by the
number of households in EU-28[^6] totals up to 790 megawatts.

In the same ballpark.

These are just numbers, but I think they show that it is possible that
power-hungry websites can potentially consume significant amount of
power by end-user computers.


----
[^1]: I'm not naming any birds, thundering or not.
[^4]: Source: [Wikipedia](https://en.wikipedia.org/wiki/Electric_energy_consumption#Electricity_Consumption_and_GDP)
[^5]: This is actually normalized to the volume of the refridgerator, but I'm willing to take a chance in taking this difference as a valid average.
[^6]: 210 million, source: [Eurostat](http://ec.europa.eu/eurostat/statistics-explained/index.php/Household_composition_statistics)
[^laptop]: 13" Retina Macbook Pro, 2013 model.
[^methods]: Most applications turned off, no Time Machine backups running, battery at 100%, not using the computer during measurements, starting measurements only 10-30 seconds after page load, pausing video until player has cached as much as possible before video plays, measuring power meter visually from a digital display at 5 second intervals for 30 seconds for a total of 7 measurements for each test.
