---
title: Energy Simulator
tagline: A sandbox simulaton of Finland's electricity market
tags: ["scala", "scala.js", "energy", "simulation"]
---

<small>(I have been quiet on this blog for quite a while. I might
offer an explanation on that at some point. Although, some of the
reasons can be found in this blog post.)</small>

During the latter part of 2017 I worked on my bachelor's thesis on
Engineering Physics at the Aalto University[^degrees]. You can find
the results online (with a short description and a link back to
**this** article) at [energysim.kooma.net](http://energysim.kooma.net)
and [GitHub](https://github.com/santtu/energysim). If you want to play
with the result, click on the first one, and if you are interested in
the code and not on a pretty long monologue, click on the second one.

Also, in case you want to get really sciency, just jump to reading
[the actual B.Sc. thesis](/assets/posts/energy-simulation-report.pdf).

## Introduction

There's this thing called **energy policy**. You might not know it
even exists, yet it affects you every day. Each country has one, even
if it is only implicit in the set of current policies enacted by the
government. Energy policy essentially defines the set of goals of how
energy is produced and used by a country, and the set of rules that
aim to get those goals accomplished. In the olden days, energy
policies were mostly about economics and safety of the energy
supply. Nowadays, a third axis of environmental effects must be taken
into account (especially greenhouse gases, but also particulate
emissions et al).

Even countries neighbouring each other can have vastly different
energy policies that reflect their own, particular local
environment. Norway, for example, has a huge natural advantage of
having lots of water and mountains. When these two are mixed, these
result in lots and lots of hydroelectric power. So while Norway is a
**major** oil producer, it produces almost all of its electricity from
**water**. Contrast this with France, which has taken a completely
different approach having over 70% of its electricity producer through
nuclear power. So overall, without going too much into the why's of
energy policy, let's just say that policies differ from country to
country, and there's usually good reasons beneath the differences.

Also, while I'll primarily will talk about **electricity**, please
note that "energy use" includes also the production and use of heat
(pretty important in colder climates), industrial uses and
transportation.

## Finland

So, when concentrating on my own country, Finland, and its energy
policy, one finds many interesting and conflicting drivers. At the
moment, simply put, Finland is dependent on electricity imports. The
peak electricity production in Finland is **less than the peak
demand**[^jaaskelainen]. Whether this is a problem **right now** is up
to debate, and it may even be possible that in the future the problem
will be solved through an unified all-EU electricity market. However,
things move pretty slowly in the electricity market, thus any external
beneficial effects are likely to be even more slow than any local
energy policy effects (it takes easily decades to build GWs of
production capacity[^ol3]).

Energy policy, pretty much by its definiton will be closely tied with
politics, which in turn ties into popular opinion. I do not know about
other countries, but at least here in Finland there are several trends
affecting the attitude towards energy policy in the general
population: polarization, loss of interest, lack of trust and
unrealistic production method preferences:

* There's a widening attitude gap between rural and urban
  population. While the majority of Finland's population is urban
  (>80%), due to historical reasons the rural population has a larger
  say in domestic politics than would be immediately obvious. For this
  reason, these differences cannot be disregarded.
* Some segments (read: the same segment that fancies any popular
  politic, e.g. white, male etc. etc.) are becoming jaded with the
  complexities of energy policies (yearning back to the times when you
  could just burn oil without any care in the world?), and of course,
  if the trend gains more traction will make any kind of rational
  energy policy more and more difficult as it is hijacked by popular
  politics.
* There's a marked lack of trust by the general public on politicians
  (on energy policies), of energy companies ... also there are
  examples in Finland of politicians strongly dismissing energy and
  policy experts. Not good, of course.

Unless you've lived under a rock, you should have seen where popular
politics combined with ignorance of facts can lead. So, ignorance,
not a good thing. What can be done about it?

## Show, don't tell

_I think that people are more receptive towards results they have
experienced through their own actions._ What if people could play out
their own energy policy preferences out, and see how that would affect
CO₂ emissions and the safety of electricity supply? Out of this
thought resulted the *Energy Simulator* (or more accutarely,
electricity sandbox simulation of Finland but the shorter, albeit less
accurate version has stuck). Show below are two different situations,
first the default state, and another with some ... issues:


<figure> <a href="/assets/posts/energy-simulator-cases.png"><img
src="/assets/posts/energy-simulator-cases.png" alt="Energy simulator with two
setups, one with default values and another with less than optimal values"></a>

<figcaption>Energy simulator running after running some time with
defaults (left) and several imports disabled and production
capacitities disabled or reduced (right). Light green indicate some
regional blackouts and redder colours more frequent blackouts. The CO₂
emissions on the latter are 120% higher than in the former case.

</figcaption>
</figure>

You can go ahead and play with the energy simulator
at [**energysim.kooma.net**](http://energysim.kooma.net/). I'll talk a
bit more about the technical details below and if you are so inclined,
you can check out the source code
at
[github.com/santtu/energysim](https://github.com/santtu/energysim). You
can find also a lot more background information on Finland's energy
situation, on how the energy simulator's simulation and its parameters
are modeled in
my [Bachelor's thesis](/assets/posts/energy-simulation-report.pdf).

I'll quickly touch on some non-technical issues, but after that I'll
go more into the technical details of the implementation. You can skip
rest of the post if you're not into programming (well, after some
other stuff first).

While the energy simulator is nice in itself, it is **not a game** as
it currently stands. It is an open-ended sandbox simulation, and it
has lots of caveats and shortcomings due to all of the necessary
abstraction and simplification that just getting it finished in
limited time required.

Likewise the hypothesis that using a "game" (which this, strictly
speaking is not) would be more effective in changing people's
attitudes on energy policy towards more "holistic" approach (from
where? from assumed polarized ends?) is entirely unverified. I thought
about adding a questionnaire before and after, but finally decided to
omit it simply because of schedule (results would not have made into
the BSc report).

And finally, **I am not an UX designer** and either not very good at
CSS or web layouts. There are tons of elements that I dislike yet I
could not justify myself for spending hours and hours on polishing it
from "engineering quality" to "professional quality", especially when
I needed to finish first other things more relevant from the
scientific point of view. In the end, it got finished, and I have
other things to do. Time to move on and accept it as whatever it
currently is.

## Let's get technical

* **Monte Carlo simulation.** The simulation is a stochastic
  simulation that, for each simulation round, draws random samples of
  capacities for consumption and production values[^transmission].
* **Edmonds-Karp maximum flow algorithm** is used iteratively to
  distribute electricity (from surplus production areas) in a way that
  minimises **global CO₂ emissions**.
* **Everything runs in the browser.** This is a pure single-page
  application, with everything running in the browser including the
  sandbox simulation. The simulation runs in a separate web worker
  thread so it doesn't block the user interface.
* **Scala all the way down.** While the browser runs javascript, the
  whole energy simulator -- simulator core, web worker and user
  interfae -- are all written in Scala.
* **All state in the URL.** The URL contains always contains the
  current model. You can copy and paste the URL for
  others. Uuuuunfortunately the URL is also several kilobytes in size
  and that might potentially be a teeny little problem with some
  browsers...

The use of Monte Carlo simulation came quite naturally as most of the
source data is experimental (e.g. real world) and not expressable as a
mathematical expression. This meant that performing any kind of
mathematical analysis to infer the overall properties of the system
was pretty much out of the question. The use of random sampling in a
Monte Carlo simulation results in meaningful and _accurate_ statistics
in the long run. Thus after twiddling with the parameters you can let
the simulation just run and the most prominent values (mean and
standard deviation) are guaranteed to be close to what would be the
results of an analytical approach (if ever done) to within some error
margin[^spectral].

From the very beginning I realized the simulation would need to run in
a browser. There is no way I could furnish the resources to do this
server-side! While the JVM version runs at about 500x the speed of the
JS version, there are way way way more browsers out there. I thought
about using WebCL for the simulation core to speed it up as all of the
sampling could be trivially parallelized, and even the Edmonds-Karp
algorithm probably could be ported to WebCL. However, schedules again,
and the few iterations per second I get from my old MBP on Chrome is
"good enough".

While the very first trial simulation I wrote in Python, all
subsequent development was in Scala. **But what, didn't this run in
the browser?** Yes! Thanks to the magic
of [Scala.JS](https://www.scala-js.org/), all of the simulation code
works **both** in JVM environment (at JVM speeds!)  **and** in
JavaScript (both in browser and nodejs). Only a very small amount of
glue was needed in the actual JS-only land, although since the user
interface part does interface with browser, it is very much aware of
the javascript-isms of the browser environment (global variables and
so on).

While undoubtedly the Scala.JS version of simulation is slower than a
hand-written javascript code, I considered writing code in Scala much
easier than in JavaScript. While targeting JS from Scala.JS did set
some limits on library use, for example, I think it overall offered a
much nicer environment. First of all, in the simulator core I could
run, test and debug it in scala directly. Thanks to the strong typing
of Scala I had a high confidence of it working correctly in the JS
world, too. Of course, all the unit tests on the core run in both JVM
and JS environments (nodejs for JS, not in browser). Furthermore, the
functional programming aspects made it natural to do state management,
for example --- the "world model" is an immutable data structure, and
any changes result in a new version of it. Thus any point where it is
updated becomes a natural place to update the single-page application
visible (address bar) state too.

I did the user interface using React bindings to Scala.JS. While it
took some time to learn their proper use (the distinction between
state, props and backend instances and what to use were not always
immediately obvious), I liked the result overall. What I came out
missing was an easier way to integrate with other (non-core) react
components. I ended up using a patched version of scalajs-react-bridge
— not an optimal solution, and the syntatic difference between
scalajs-react and scalajs-react-bridge usage is a visual irritation.

While all of the model is encoded in the URL, this may result in
problems as the URL is a teeny bit long (it is Base64-encoded JSON
file). Passing the model via URL does have the benefit that it is
possible to pass URLs around. I am not sure how URL shortening
services will react to several kilobytes of URL, though...

Okay, the technical bit came out as a bit of a ramble. In case you are
interested in more details, or would like to extend or re-use the
energy simulator please don't hesitate to contact me with questions!
Also, in case you are reading this in 2020 or so you probably should
check out the [repository](https://github.com/santtu/energysim) first
as it _might_ be more up-to-date.

----
[^degrees]: Not my first degree.
[^jaaskelainen]: Jääskeläinen et al, _Adequacy of power capacity during winter peaks in Finland_, DOI: [10.1109/EEM.2017.7981883](https://dx.doi.org/10.1109/EEM.2017.7981883)
[^ol3]: This can be attested by the Olkiluoto 3 nuclear power plant project which has taken over a decade longer than planned.
[^transmission]: Transmission line capacity is also sampled, but for simplicity they were modeled at constant capacity (e.g. no failures, no capacity variances).
[^spectral]: The "MC results approach true values" argument has several requirements that are not necessarily satistfied in this case, though. The quality of the random number generator in JavaScript is questionable, for example.
