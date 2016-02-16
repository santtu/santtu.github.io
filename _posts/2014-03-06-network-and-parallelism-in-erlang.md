---
layout: post
title: "Sockets and concurrency the buggy way"
tagline: "How to introduce a subtle race condition"
tags: ["erlang", "network", "programming", "concurrency"]
---

**Updated 2016-02-16: I have added more explanations below pointing
out that the race condition I describe will only affect sockets with
`{active, once}` option. See below.**

I'll once again share a small gotcha moment from recent programming
experiences. This comes from my jab at [Erlang programming](
{% post_url 2014-03-03-experiences-in-erlang %}) and concerns about a
*very* subtle bug I introduced into the hypercube node code I was
writing.

With subtle I do mean *subtle*. It took a specific set of conditions
to manifest the bug. It had a tiny time window at system startup where
it could be triggered and never again after that. I finally could
reproduce the bug somewhat reliably by starting a total of 1024 node
processes in less than 1/4 second, in parallel, in multiple 16-core
physical servers— and even then it showed up in only for one or two
network connections out of 10240 connections that were created during
the system initialization.

> As most bugs go, this is obvious once you realize the underlying
> problem. For long-time Erlang programmers this might be a known
> problem and avoided without a second thought.

## What I tried to do

So I'm writing this post hopefully help anyone who might run the same
problem. But before delving into the actual bug let me first tell what
I was trying to do:

1. I wanted to have a server listening on a port, where
2. Each new connection would be handled by a spawned Erlang process
   (e.g. in a separate thread)

There are two ways to process incoming traffic on a socket in Erlang:

* Use `gen_tcp:recv` in a loop to receive input, then process it. This
  is the typical approach taken to network programming in
  <strike>most</strike> all languages.

* Use Erlang's (unique?) method of **active sockets** where the Erlang
  runtime will send incoming network traffic to as messages to the
  socket's controlling process.

**I decided to use the latter method.** It fits nicely into Erlang's
view of the world where asynchronous interactions occur via
messaging. It also allows nice integration with other processes since
you can handle **both** Erlang-world messages and non-Erlang-world
interactions in the same `receive` loop.

### Using an active socket in a network client

Here's an example Erlang program to connect to port 12345 on
localhost, reading data from the socket and printing it out:

~~~ erlang
main(_) ->
    {ok,_} = gen_tcp:connect("localhost", 12345,
			     [{active, true}, {packet, line}]),
    loop().

loop() ->
    receive
	{tcp,_,Data} ->
	    io:format("Received: ~ts", [Data]),
	    loop();
	_ ->
	    io:format("Error or socket closed, exiting.~n"),
	    halt(0)
    end.
~~~

To try this out, put this into a file and, run `echo hello | nc -l
12345` in another terminal and use `escript` to run the script. Of
course you need an [Erlang
installation](http://www.erlang.org/download.html) in the first place.

The program opens a connection with `{active, true}` socket
option. This sets the connected socket into active mode. Incoming data
is then processed by `loop` which keeps calling `receive` in a loop
until the socket is closed (or an error occurs).

### Using active sockets in a network server

A socket server with active sockets is also straightforward (**except
don't use this code, see below**):

~~~ erlang
%% WARNING: Don't use this code, it contains a race condition. See below.
main(_) ->
    {ok,S} = gen_tcp:listen(12345, [{active, false}, {packet, line}]),
    server_loop(S).

server_loop(S) ->
    {ok,C} = gen_tcp:accept(S),
    Pid = spawn(fun () -> connection_loop(C) end),
    gen_tcp:controlling_process(C, Pid),
    server_loop(S).

connection_loop(C) ->
    inet:setopts(C, [{active, once}]),
    receive
	{tcp,_,Data} ->
	    gen_tcp:send(C, Data),
	    io:format("~w Received: ~ts", [self(), Data]),
	    connection_loop(C);
	_ ->
	    io:format("~w Error or socket closed, closing.~n", [self()]),
	    gen_tcp:close(C)
    end.
~~~

This program will bind to port 12345, accept connections on the port,
spawn an Erlang process for each connection which in turn will echo
all traffic back to the originating socket. Test it out with `echo
hello | nc 12345`.

You might be wondering about `gen_tcp:controlling_process`, `{active,
false}` and `{active, once}` in the code:

* When a socket is in *active mode* it will send packets to the
  **controlling process** which is initially the process that created
  the socket. Thus `server_loop` must explicitly give control of the
  socket to the `connection_loop` process.

* Similarly we don't want the server process to receive any packets,
  which is why the listen socket is defined as `{active, false}` —
  this setting is inherited to the accepted socket so it will also
  start in inactive mode.

* Finally, the connection handler sets the socket `{active, once}`
  which is mostly similar to `{active, true}` except it adds flow
  control to the mix. Which is a good thing before trying to drink
  from a fire hose …

### But it has a race condition!

If you were not dozing off you've realized that **this version has the
race condition** I mentioned earlier. The race occurs when code is
executed in a particular sequence and the client is sending data at
just the right moment.

Below is a figure showing two possible sequences of events within the
code, on the left is a sequence with **the desired (working) outcome**
and on the right side is another but possible **sequence which doesn't
work** (there are a few more "bad" execution sequences, but I'll use
just one as an example):

![Two possible execution paths in the sample server code]({{site.url}}/assets/posts/erlang-socket-sequence.svg)

In the figure <span style="background: #ff9da6; padding: 0 0.2em;">red</span> is `server_loop` code, <span style="background: #42ff7e; padding: 0 0.2em;">green</span> is `connection_loop` code and
<span style="background: #71beff; padding: 0 0.2em;">blue</span> is
Erlang's internal-ish network-ish code handling incoming data for active sockets.

What we want is that the connection handler (`connection_loop`) will
receive all data that is sent to the connected socket. Just like
happens in the left sequence — data is received on the socket after
socket's ownership has changed and the handler code is ready to
receive data.

On the "bad" sequence the child process will set the socket to active
state **before the parent process has changed the socket's
ownership**. This means that any data received on the socket before
ownership change is **sent to the wrong process**. The recipient will
be the listener process and not process running `connection_loop`
code. Oh boy, the data is now lost. <small>(Technically it's not
lost. It is just unread in the message queue of the wrong
process. Regardless, it is never read.)</small>

> I wrote [in the previous post]({% post_url 2014-03-03-experiences-in-erlang %}) *"[Erlang's] shared-nothing
> process model removes most problems with shared resources."*
> Yep. Erlang removes most race conditions on shared resources by
> **eliminating most shared resources**. When resources **are** shared
> such as on-disk files or *network sockets* there can still be
> concurrency problems.

If this would be a real server process with request-response protocol
and client-initiated handshake, then the connection would also be
stuck permanently (server never sees the handshake, yet client has
successfully sent it and is expecting a reply).

> I want to emphasize how difficult this bug is to trigger. The remote
> client will not be sending data until the TCP handshake
> completes. When `listen` returns, the TCP stack has already sent a
> SYN-ACK packet to the client. After it reaches the client it can
> start sending data, but this will take with any Internet connection
> anything from a few milliseconds to hundreds of milliseconds.
>
> I instrumented the code, showing that `server_loop` took (on a
> MacBook) on average 103 µs (99.9% percentile was 170 µs — these are
> microseconds e.g. 1/1000th of a millisecond) to spawn a process and
> hand the controlling socket over. Thus unless the server is
> massively overloaded it is nigh-on impossible to trigger the bug
> over the Internet and difficult even on a local network (the network
> I used has ~150 µs average packet latency).

**The next few paragraphs were added on 2016-02-16. My thanks to
Robert Gionea for pointing out the distinction between `{active,
true}` and `{active, once}` in how parent process queue is handled.**

Robert's email got me looking much more closely on the bug and digging
deep into Erlang runtime's internals which means I can now give out
the exact conditions what cause the bug to occur — there are two
conditions that need to hold so that the code above may lose a packet
due to a race condition:

1. SMP is enabled (enabled automatically on multicore/multiprocessor
   systems).
2. Child process modifies socket's `active` state **while** socket's
   ownership is being transferred (parent calls
   `gen_tcp:controlling_process`.)

See [ERL-90](http://bugs.erlang.org/browse/ERL-90) bug report for
much, much more in-depth description of the actual underlying
problem - it has surprisingly old roots, probably being the side
effect of introduction of SMP capability introducing a new failure
mode to `gen_tcp:controlling_process` that was not fully appreciated
at that time. The fix discussed below prevents the second condition
from happening and thus also prevents the race condition from
occurring.

(End of 2016-02-16 edit.)

### De-bugged versions of the server code

Fixing this is easy once the problem is identified: just add a
synchronization barrier to ensure that `connection_loop` won't be
called until the parent process has relinquished its control on the
socket:

~~~erlang
%% Version spawning off a process to handle the connection.
server_loop(S) ->
    {ok,C} = gen_tcp:accept(S),
    Pid = spawn(fun () -> receive start -> ok end, connection_loop(C) end),
    gen_tcp:controlling_process(C, Pid),
    Pid ! start,
    server_loop(S).
~~~

Since this race condition occurs only when **not** using `recv` and
**switching controlling process** there are also two other ways to
write the code so the race condition never occurs. First one is to
eliminate the need to use `controlling_process` by spawning a new
process for the listener instead:

~~~erlang
%% Version using the current process to handle the connection, passing socket
%% listening to a spawned process instead.
server_loop(S) ->
    {ok,C} = gen_tcp:accept(S),
    spawn(fun () -> server_loop(S) end),
    connection_loop(C).
~~~

and the other is to **not** use active sockets at all:

~~~erlang
%% Version eliminating active sockets completely using gen_tcp:recv only.
server_loop(S) ->
    {ok,C} = gen_tcp:accept(S),
    spawn(fun () -> connection_loop(C) end),
    server_loop(S).

connection_loop(C) ->
    case gen_tcp:recv(C,0) of
	{ok,Data} ->
            ...;
	_ ->
            ...
    end.
~~~

### <a name="concurrency"></a>Concurrency …

This should be a reminder that **concurrency is hard**. (If you don't
believe me, check what [Simon Peyton
Jones](http://en.wikipedia.org/wiki/Simon_Peyton_Jones) says about
[what's wrong with
locks](http://research.microsoft.com/en-us/um/people/simonpj/papers/stm/STM-OSCON.pdf).)

I have programmed in concurrent environments for decades and I do
consider myself to be highly skilled in concurrent and parallel
programming (multi-thread, multi-process and multi-machine all
alike). (And yet I still fail.) Over my programming history I've seen
that almost all novice programmers and even most senior programmers
**1)** try to avoid using concurrency in the first place, **2)** not
realizing when they've accidentally created concurrent systems and
finally **3)** when having to face concurrency they often get
synchronization and sequencing wrong (leading to hard-to-find bugs).

<figure>
<img src="{{site.url}}/assets/posts/parallel-rail-tracks.jpg" alt="Parallel railroad tracks">
<figcaption>Parallel tracks. Get it? Parallel - parallelism? I know, I know … (Image source: <a href="http://www.flickr.com/photos/callmewhatever/9552127269/">Daniel Zimmermann</a>)
</figcaption>
</figure>

I think this makes for a very good case to **prefer systems which
provide better and safer concurrency programming models**. This way at
least the most common concurrency problems get eliminated entirely by
design.

In modern hyperthreaded multi-core computer architectures the ability
to use multiple cores efficiently is a key to high-performance and/or
responsive applications and services. In scalable architectures
concurrency also is an important tool and similarly a problem (though
it comes in different guise through Brewer's theorem).

Yet performance or parallelism should not be gained at the cost of
**correctness**. For this reason I think that the approach to
concurrency and parallelism taken by most languages is unproductive —
where the programmer is given low-level primitives (threading,
mutexes) and then left to sort the rest by themselves. There should be
much better support.

To see some examples of how concurrency and parallelism can be made
simpler for programmers see [a presentation on multicore
Haskell](http://donsbot.wordpress.com/2010/06/01/open-source-bridge-talk-multicore-haskell-now/),
Learn you some Erlang's [section on
concurrency](http://learnyousomeerlang.com/the-hitchhikers-guide-to-concurrency)
or introduction to Clojure's [concurrency and STM
mechanisms](http://www.youtube.com/watch?v=dGVqrGmwOAw)
([slides](https://github.com/dimhold/clojure-concurrency-rich-hickey/blob/master/ClojureConcurrencyTalk.pdf?raw=true)).

I don't think concurrency is never going to be easy, but let's at
least try to figuratively default to giving new programmers a bicycle
instead of an unicycle?
