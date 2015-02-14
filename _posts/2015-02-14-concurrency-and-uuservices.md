---
layout: post
title: "Divine concurrency"
tagline: "C$PAR DOALL"
tags: ["µ²services", "concurrency"]
---

In [previous post]({% post_url 2015-01-31-path-ahead-uuservices %}) I
described µ²services, a system development model that is based on
extrapolation of current trends in microservices and shrinking
containers. I argumented that potential benefits of µ²service model
*might* outweigh its costs. But are µ²services really technically
feasible?

In this and future posts I'll go through some of technical details
both from feasibility and benefit points of view, with probably one
idea per blog post to keep them manageable in size.

To summarize [µ²services]({% post_url 2015-01-31-path-ahead-uuservices %}): µ²services is container-per-request model where a new
virtual machine[^1] is created for
**each request** made to the service which then handles the request
**and only that request** and is destroyed after response is
generated.

**A warning for the reader:** All of this is pure speculation on my
part. µ²services might happen, but they might not. This is
futurology. **Do not think this is technology that currently exists**
(although technological precursors exist.)

## <a name="concurrency"></a>Divine concurrency

I have previously argued that [concurrency is hard]({%post_url 2014-03-06-network-and-parallelism-in-erlang%}#concurrency) and developers should primarily use language and software architecture constructs that naturally result in *safe code*. I think µ²services offer a way to create **massively parallel** service architectures where risks associated with concurrency (dead- and livelocks, mutable data and so on) are either completely eliminated or largely reduced and limited in scope.

The graph below shows a hypotethical call dependency path for a
request. The service is composited of multiple smaller (micro)services
which themselves are a group of µ²services. State is managed
separately and the state storage mechanism is shared by all of these
components (via a deployment configuration parameter). The graph could
describe a conventional service as well where the colored blobs would
signify a service process boundary and circles functional elements
within the service.

<figure>

<a href="/assets/posts/uuservices-flow.png"><img
src="/assets/posts/uuservices-flow.png" alt="Call graph of a request
to µ²service"></a>

<figcaption>µ²services responding to a request to `/listings` --- so
far this looks like a regular microservice.. (Letters and numbers
match those in the second graph.)

</figcaption>

</figure>

In an µ²service the colored blobs are **service** boundaries, a
mechanism to group several different µ²service endpoints
together. Perhaps they all share the same configuration elements, or
same repository and release tag or similar. With µ²services a
"service" is more of a convention than a fixed entity.

Individual circles represent separate µ²service endpoints, pieces of
code that can be invoked externally by either users or other
µ²services. When not running these are essentially **templates** that
are instatiated when a request is received. Thus each inbound arrow in
the call graph represents a **new virtual machine** that starts to run
the **service code**. For example, calls *c* and *f* run the same
function[^2] but in *different* virtual machines. Same applies for *n*
and *o* which result in *different* virtual machines 13 and 15.

As described, all µ²service call graphs are acyclic — while calls "up
the chain" are logically possible, they result in separate instances
making the physical call graph acyclic. The graph below is another
view of the same call graph, but structured to make it clear that
there exist only forward dependencies. It shows the lifetime of each
call (virtual machine), where each either creating a new virtual
machine (request) or resulting in a termination of one
(response).

<figure> <a href="/assets/posts/uuservices-vms.png"><img
src="/assets/posts/uuservices-vms.png" alt="Virtual machine
invocations and terminations on a request to µ²service"></a>

<figcaption>Virtual machines running concurrently when processing the
request in the earlier graph.

</figcaption>
</figure>

Concurrency is **difficult** in monolithic services. A single spinning
thread can block the whole system. Microservices offer a potential for
increased concurrency by
[allowing concurrent requests to dependent services](http://techblog.netflix.com/2013/02/rxjava-netflix-api.html). µ²services
with even finer service decomposition has the potential to offer even
more concurrency.

Note also that since each service-to-service request is explicit they
can be separately
[managed for failures and timeouts](https://github.com/Netflix/Hystrix). Timed
out requests are no longer left running — terminated requests will
result in termination of their container, which will propagate request
terminations further down the chain. For example in the graph above if
the user terminated the request (closing the HTTP connection), it
would cause instance 1 to terminate, followed recursively by all
dependent instances. This would occur even if some code was stuck in
an infinite loop[^3]!

Like all things, µ²service model is not a magic dust that could turn any
system into massively parallel system. It is not, and cannot be. What
it can do is what [Erlang as a language]({%post_url 2014-03-06-network-and-parallelism-in-erlang%}#concurrency) has done —
it can make concurrent programming a little less error-prone. One benefit — compared to Erlang at least: using a different service **model** does not require you to learn a new programming **language**.


*That's all this time. I would appreciate any comments on uuservices —
 please share your thoughts by adding a comment below. Thanks.*

----
[^1]: I'm using "virtual machine" to emphasise the isolation between µ²services. Zones, containers, schmontainers, whatever… as long as all service calls are both spatially and temporally isolated.

[^2]: With **function** I primarily emphasise µ²service's difference to traditional monolithic services or even microservices. **µ²service functions** are not **programming language** functions — `image.flip()` is a local function call that occurs within the runtime environment of the µ²service instance.

[^3]: Here's a question on your favourite web service framework: If you make a `GET` request handler that will sleep for a minute and make a request to it killing the client **immediately** after request has been sent. **When will the request handler terminate?** Immediately on receiving TCP FIN? After the sleep completes? Somewhere in between?
