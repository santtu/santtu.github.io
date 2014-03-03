---
layout: post
title: "Experiences in Erlang"
tagline: "you ! {will,understand,self()}"
tags: ["erlang", "programming", "python", "haskell"]
---

I got an programming assignment in a course I was taking. The task was
to create an overlay network topology and implement a routing protocol
for it with some given constraints — where I quickly realized a
hypercube mesh would meet the rating criteria. (This shows my age —
hypercube networks were a hot topic in the 90's. They were used in
supercomputers such as the [CM-5](http://en.wikipedia.org/wiki/Connection_Machine).)

Unfortunately a binary N-cube routing algorithm is **pretty much
trivial**. Here's the whole routing algorithm written in Erlang:

```erlang
find_route(_,_,[],_) ->
    {error,noroute};

find_route(Id,Dst,[Route|Routes]) ->
    if Id band 1 /= Dst band 1 ->
            {ok,Route};
       true ->
            find_route(Id bsr 1, Dst bsr 1, Routes)
    end.
```

That's it. 8 lines of code. The first function could be omitted
(deducting two lines) as it guaranteed to be never called. (`Id` is
this node's address and `Dst` is destination address, each element in
the `Routes` list is a neighbor in the matching dimension.)

Since the actual *network problem* became trivial you can see why I
picked up Erlang. It was for the sole purpose of **making the
assignment more interesting**. I had not previously used Erlang — I
was familiar with the syntax and could *read* Erlang programs — but
all the libraries, conventions etc. were new to me. I knew of Erlang's
approach to distributed computing and parallelism and wanted to give
it a spin.

So, what I learned? I'll first summarize its pros and cons from my
viewpoint and later elaborate on these:

<table>
<thead>
<tr><th>Pros</th><th>Cons</th></tr>
</thead><tbody>
<tr><td>
<ul>
<li>Language and core libraries are compact, consistent and mature</li>
<li>Built-in concurrency and messaging</li>
<li>Pattern matching</li>
<li>Symbols are always sexy</li>
<li>Registered processes</li>
</ul>
</td>
<td>
<ul>
<li>Cryptic compile-time and runtime errors</li>
<li>Package management</li>
<li>Structured data ~ painful syntax</li>
<li>No hierarchical namespaces</li>
<li>Registered processes</li>
</ul>
</td></tr></tbody></table>

The overall result for me is:

* Erlang is a very nice language, it has great features and I'd love
  to use it again.
* … but it won't become my default go-to language.

**Please note** that I'm basing this post on my experiences. I might
have missed or misinterpreted things that are obvious to other people,
so don't take this post as any kind of gospel truth of Erlang.

----

Now the long version. Erlang is really nice in several aspects:

* The language is compact and consistent and the standard libraries
  are mature (e.g. well documented and debugged). There's also a good
  variety of non-core libraries available which I didn't have any
  trouble of using.

* Its built-in support for massive concurrency and distributed
  messaging are just manna from heavens.

  Erlang's lightweight process model just kicks ass. I've spawned 15k
  Erlang processes (e.g. threads) without problems whereas in Python
  1000 threads? Forget it (you'll hit the `maxproc` limit). 99.99% of
  the time parallelism is a tool to achieve asynchronous behavior so
  that case should be as least limiting as possible. Like Erlang does
  (it runs green threads on multiple native threads, getting the best
  of both worlds).

  Also the shared-nothing process model removes most problems with
  shared resources. It does make some things more cumbersome and less
  efficient, but hey, I'm quite willing to trade a little inefficiency
  to programming with a massively less error-prone concurrency model.

* Pattern matching in functions, assignment and conditionals is
  sinfully easy. Don't care to handle errors, but still want the
  process to fail when they occur? `{ok,Result} =
  maybe_failing_function()` — if the function *does not* return
  `{ok,_}` the runtime will signal that as an error. And of course
  *guards*.

* Symbols are always a good thing. Scheme, Ruby and Erlang (among
  others) do this right. Oh Python, when will you realize symbols are
  a very useful first-class citizen?

* Registered processes. They are very useful when they fit the need,
  but see below when they *don't*.

On the minus side there are a few things that will mean that Erlang
won't be my choice as a default go-to language in the future:

* Compiler and runtime errors. So I forgot to make the variable
  uppercase and now it thinks I want to do pattern matching with a
  symbol? My bad. But you just should give a less cryptic error
  message about it.

* Package management. [Rebar](https://github.com/rebar/rebar) can pull
  dependencies automatically, but there's still a world of difference
  between writing `PyYAML` into `setup.py` vs. writing `{jiffy,
  "0\.8\.5", {git, "https://github.com/davisp/jiffy", {tag,
  "0.8.5"}}}` into `rebar.config` *over and over again*. This is not a
  problem for large projects where dependency setup is one-time-only
  affair, but when doing smaller or one-off programming jobs it does
  add up quickly to the workload.

* Horrendous syntax for structured data. Changing a field? `NewStruct
  = Struct#struct{value=Struct#struct.value + 1}` A little syntatic
  sugar here would do miracles. Yes, you can use parse transformations
  to help. But that then gets you into another problem of having to
  *first* get those parse transforms (see previous) and *second* to
  apply them.

* Registered processes. These are nice, I would very much want to use
  them but can't. The idea is that you can register processes by name,
  say identify the router process as `router` and use it directly in
  messaging like `router ! {route,Packet}`. Add a supervisor which
  will re-spawn a failed router thread you've got a model where you
  always know how to reach a working "router" process.

  Except registered processes are global. I needed to run multiple
  hypercube nodes in a single server process, with *each* having a
  *separate* router and *separate* local message handler and
  *separate* remote connectors and *separate* state manager.

  I think this is due to the history of Erlang. It was designed to run
  in a loosely coupled but purpose-designed system (telco
  exchanges). In that context it made perfect sense to have a globally
  identified process. After all, there was only a single system, so
  why there would be any need for multiples of any single process?

  Which does not work in a multitenancy scenario where you have
  multiple "domains" of processes, where intra-domain visibility is a
  good thing but inter-domain visibility is verboten.

  So I was stuck to using the process dictionary and lugging process
  identifiers around in function arguments.

* Lack of hierarchical namespaces. It is two levels and only two
  levels. Module and function name and that's it. So when your
  `frobnizer` app needs to have internal module, it is
  `frobnizer_internal_module` and not
  `frobnizer.internal.module`. Module hierarchy and scoping isn't
  [only syntatic
  sugar](http://stackoverflow.com/questions/4503131/why-arent-erlang-packages-used)
  regardless what hard-core erlangistas say. I personally have found
  module hierarchy and its close ally, scoping rules a useful feature
  in other languages. So why not here? I don't understand the
  opposition for such [a simple and
  non-intrusive](http://www.erlang.se/workshop/2002/Carlsson.pdf)
  change.

I love Erlang's pragmatic approach to functional programming,
contrasted with Haskell for example, which as a language I simply
admire but
Always. Find. It. Painful. To. Do. Anything. Useful. Using. It. We
don't write programs (at least mostly) for the pleasure of seeing
beautiful and pure programs. We write programs to get things *done* in
a *real-world* environment where *interactions* with that
non-functional world is the primus motor. So why make *that* painful?

Erlang is a functional language which understands its purpose of
interacting with the non-functional real world. Functional but does
not try to whack you with the *+4 Mace of Lambda the Pure* every time
you interact with the world.

----

Interestingly I see a pattern in my choice of programming
languages. The languages I use the most have the following traits:

* Good package management with a centralized package directory.
* Ability to write quick one-off programs easily (scripting).
* …

I could add "nice syntax" etc., but that's beside the point. I don't
do non-nice languages. I want to retain my sanity. (So goodbye the
lucrative MUMPS jobs there.)

In a world where you **do not** write your own JSON parser, networking
library, UI framework, HTTP request processor etc. etc. the ability to
**easily** discover, pull and manage external dependencies is
important. My life is too short to waste on libraries and languages
which start with "to install, first … then … then" instead of `pip
install thispackage` or even "download, unpack, `./configure && make
install`".

Somehow Erlang falls short of my definition of "good package
management" and "good scripting". Not by much, but still.