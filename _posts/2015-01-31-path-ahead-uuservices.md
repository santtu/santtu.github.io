---
layout: post
title: "µ²services"
tagline: "Docker and evolution"
tags: []
---

Previously I started [playing the futurician]({% post_url 2015-01-06-trans-earth-protocols %}), a path I'm now continuing against all good advice. I've always envied "visionaries" at companies as they get to play around without any kind of responsibility (they will have long since flocked elsewhere when their predictions can be checked). Similarly I am planning to make bold predictions of a future so far away that a claim of flying pigs would have equal credibility.

## State of the art

Unless you've lived under a rock, you must have heard of
[Docker](https://www.docker.com/) (and its take by
[AWS](http://aws.amazon.com/ecs/),
[Google](https://cloud.google.com/compute/docs/containers) and
[Azure](http://news.microsoft.com/2014/10/15/dockerpr/)), a kind of
applications-on-(almost-)virtual-machines containerization mechanism.

Yet docker is just one evolutionary step in a long path of application
deployment models. Way way back during pre-history computers were
expensive and *so* much slower that CPU cycles were *soooo* expensive
it made sense to cram as much services into a single server to
minimize operating and capital costs. This was the era of mainframes,
followed by minicomputers and later UNIX servers as relative hardware
costs kept decreasing. Although the per-cycle cost decreased, for a
very long time the tendency to run multiple services in a single
server remained.

The widespread rollout of first server virtualization, then of "The
Cloud", allowed large servers to be splitted into smaller, discrete
virtual machines. This made it feasible and later commonplace to run
only a single service per virtual machine. This step is also crucial
for later adoption of deployment automation as it allows each service
to be equated with a machine, vastly simplifying problem resolution —
there is no fear of hurting "other" services when rebooting (or
re-creating) a one-service machine.

Docker is one step in this path of shrinking (relative) deployment
footprints. **Fundamentally** it does not differ from a
service-per-machine model as its containers have in practice similar
isolation properties as earlier service-per-virtual-server model. **In
practice** it is a major step: Virtual machine startup latency is
anything from half a minute up while a docker container the startup
time is in seconds to tens of seconds range. Other overheads such as
memory and disk use are also reduced — for a single server these
latencies and overheads would not matter much, but in the scope of
cloud services with thousands of servers these seconds and gigabytes
start to add up.

<figure> <a href="/assets/posts/mainframe-to-cloud.png"><img
src="/assets/posts/mainframe-to-cloud.png" alt="Service deployment and
cost development"></a>

<figcaption>Service deployment speed has increased while the cost to
run a service has simultanously decreased. (Images courtesy of <a
href="http://commons.wikimedia.org/wiki/Main_Page">Wikimedia
Commons</a> and <a
href="https://www.flickr.com/photos/osde-info/7948643886/in/photostream/">Clive
Darra</a>.)</figcaption>

</figure>

Coincident to this evolution — or perhaps co-evolved — are
[microservices](http://www.infoq.com/interviews/adrian-cockcroft-microservices-devops). Microservices
in their core are *services*, but scaled down so that a single service
performs only narrowly defined operations. User-visible services are
in not monolithic services, but are created as a composite of multiple
microservices orchestrated together. For example see
[netflix blog](http://techblog.netflix.com/2012/06/netflix-operations-part-i-going.html)
for discussion on how their business runs hundreds of services on
thousands of machines. This development mirrors the
service-in-a-machine trend by shrinking *services* providing further
benefits for simplifying and speeding up deployments.

So, that's the situation *now*. There is an architectural trend
towards distributed, asynchronous, microservice-based
systems. Simultaneously the environments these services are deployed
into are becoming both more numerous, smaller in footprint, easier to
automate and faster to deploy to.

----

Here's a mind-bender for you. Ever heard of **Erlang on Xen**? Here's
a [quote](http://erlangonxen.org/test/latency) of what it can do:

> "On average, only **49ms** passes between two moments when the Ling
> guest kernel is entered and the first Erlang instruction is executed
> by the virtual machine." (emphasis added)

Now …

<div style="margin: 3em 0; text-align: center; font-size: 200%; color: #ddd;">&lt;your thoughts here&gt;</div>

… your eyes skimming to this line took more than those 50
milliseconds. That is **human-scale fast**. Fast enough a human
pushing a button would no longer detect if each button push was
handled by a separately started Ling instance.

----

Where is this trend taking us?

* Towards more fine-grained service decomposition, and
* Smaller and simpler containers for services to run in

There are of course plenty of caveats. You can only go so far in
decomposition and reductionism. There's some lower limit for container
size. They don't matter overall — at least as arguments go — as we can
use extrapolation from these to catch a a glimpse of a future — the
future of **µ²services** — microservices to the second power.

## µ²services

µ²services are a logical conclusion of decreasing container size and
decreasing deployment unit sizes.

Each µ²service is a **pure function** with no state running in a
**virtual machine** that is alive only for the **duration of the
request** to the µ²service.

Every invocation of a µ²service results in creation of **a separate
virtual machine**<a name="1back">[<sup>1</sup>](#1)</a>, created from
scratch and torn down immediately after. This means the path of control
flow differs between a "conventional" service and an µ²service — see
the figure below.

<figure> <a href="/assets/posts/uuservices-comparison.svg"><img
src="/assets/posts/uuservices-comparison.svg" alt="Conventional
vs. µ²services"></a>

<figcaption>Comparison of more conventional service implementation
(left) and µ²services (right) responding to a <tt>GET /</tt> request
on a REST-styled service with multiple operation
endpoints.</figcaption> </figure>

On the left the request is first terminated by a load balancer or a
reverse proxy on another machine. The application server receives the
request and its dispatcher (path mapper) decides which routine to
route the request. On a µ²service architecture the dispatcher (path
mapper) spawns virtual machines which each runs only a single routine,
and these virtual machines act as the endpoints of path routing.

This sounds stupid. &lt;BLINK&gt;Super stupid.&lt;/BLINK&gt;

Creating a new virtual machine to separately process each request,
alive only a for a few milliseconds seems, nay, **is** absurdly
inefficient.

Yet … for the rest of this post I'll walk you through for why **I
think** this is not stupid, but instead at least a **possible
endpoint** based on current trends. You'll be the judge on how likely
it is.

(I'll go through some of the potential implications of µ²services from
a technical viewpoint in a later post.)

### Co-evolution

There are different drivers and trends that are co-evolving
together. The trend of shrinking containers requires automation to
realize the benefit of speedier deployments. Microservice
architectures and service decomposition trend provide a use case for
smaller but more numerous containers and again, decoupling development
teams again requires increased use of automation. Finally the
introduction of functional into the mix is making the separation of
state if not easier, at least cleaner. There is no clear head or tail
in this mix — all of these trends are driving each other.

<figure> <a href="/assets/posts/uuservices-drivers.svg"><img
src="/assets/posts/uuservices-drivers.svg" alt="Trends
co-evolving"></a>

<figcaption>Multiple trends are co-evolving together with feedback
cycles. Some concerns such as security are affecting these trends, but
they are not as such affected themselves.</figcaption> </figure>

Throw security in too, as it favors separation of concerns and
role-based access control, which are easier to implement in a loosely
coupled, decomposed service with containers with clearly defined
boundaries and lifetimes. All in all I think this will drive *at least
some services* to the logical conclusion of:

* **Minimal containers** in both minimal complexity, minimum size and
  shortest possible lifetime
* **Minimal fundamental service components**, where the fundamental
  components have no state and separated from each other during
  run-time

### Benefits

Moving from service-per-container to a request-per-container
essentially **removes sharing**. Even with *stateless* services there
is an *implicit* request-to-request resource sharing of memory, disk,
processor and network. Such sharing is a potential problem for
security, performance and resource management. Running each request in
an isolated, separate container offers several potential benefits:

* Increased security
* Increased flexibility
* Increased reliability
* Increased scalability
* Increased elasticity
* Increased efficiency
* Simplified resource management

All of this of course comes with a price to pay. Deployment automation
is a **must**. Hands-on debugging becomes **harder**. Risk of
**unexpected emergent behavior** increases. **Pervasive service
monitoring** becomes critical.

Yet all of these costs have been paid many times over. They were paid
when operations moved from many-services-per-server model to a
service-per-server model. To distributed services running on many
servers. To virtual servers with ephemeral lifetimes. To having no
servers at all, with the code just "running out there". Concurrently
new methods were developed to deploy, monitor and debug.

Thus my argument is that **there are environments where the cost of
following µ²services model will be outweighted by the benefits it
provides**. Not in all — most likely only in a minority, but in some.

What is unclear is whether these benefits outweigh the investment cost
of developing all the required technology, practices and learning to
use it in the first place. Will there be enough motivation to actually
realize it? Unknown. As I said, this is a *possible* future. Computing
history is littered with technologies that *could* have become
dominant, but did not.

----

<a name="1">[<sup>1</sup>](#1back)</a> Replace "virtual machine" with
"container" if you will. I'd guess something else entirely, but what?
Something in between those two?
