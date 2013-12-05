---
layout: post
title: "Idempotent PUT is a fake"
tagline: "Do. Not. Create. Objects. On. PUT."
tags: ["rest", "web"]
---

Previously I poured my thoughts on [REST/JSON protocol differences](
{% post_url 2013-04-12-can-you-blog-in-github %}). I am still researching
on how different server and client frameworks work, but as an
interlude I'll comment on the interpretation of the `PUT` operation in
relation to its use on "RESTful" APIs.


I've seen a lot of people state that `PUT /resource/<id>` should
create the resource if it does not exist. Like
[here](http://www.slideshare.net/stormpath/rest-jsonapis/23),
[here](http://stackoverflow.com/a/12957114/779129) and
[here](http://stackoverflow.com/a/630475/779129) and and and.

This is absolutely **wrong**. This is a misinterpretation of
*idempotency*. Following this logic to the extreme causes both
*semantic* and *practical* problems.

### <a name="idempotency"></a>Idempotency

I am making a strong statement here regarding PUT semantics here, so
let me first introduce you to the idea of idempotency. I'll quote from
the [wikipedia entry on
idempotence](http://en.wikipedia.org/wiki/Idempotence):

> Idempotence (/ˌaɪdɨmˈpoʊtəns/ eye-dəm-poh-təns) is the property of
  certain operations in mathematics and computer science, that can be
  applied multiple times without changing the result beyond the
  initial application.

And here is a small light switch system which has both idempotent and
non-idempotent functions:

```scheme
(define lights-state #f)
(define (lights) lights-state)
(define (lights! on-or-off) ...) ; sets lights on or off
(define (lights-toggle!) (lights! (not (lights))))
```

If you repeatedly call `lights`, you'll get the same value every
time. The getter is both safe (no side effects) and idempotent
(returns same value on repeated calls). Similarly `lights!` is *not*
safe (it has a world-changing side effect) but is idempotent:

```scheme
> (lights! #t) (lights)
> #t
> (lights! #t) (lights)
> #t
```

(`lights-toggle!`, of course, is not idempotent.)

Now you are asking me what's in the `lights!` function I didn't show
you earlier. I'll show you now:

```scheme
(define (lights! on-or-off)
  (if (and (boolean? lights-state) (boolean? on-or-off))
      (set! lights-state on-or-off))
  lights-state)
```

This is an idempotent function. As long as `lights-state` stays
boolean (guaranteed if only `lights!` or `toggle-lights!` are used to
change light state) it will change the value of `lights-state` to
match the request.

Now the surprising bit. If `lights-state` is not a boolean value,
`lights-state` is *still* an idempotent function and `lights` and
`lights!` are too!

Now consider a multi-user system (aka real world) where this happens:

```scheme
Me> (lights! #t)
=> #t
Elsie> (set! lights-state 'explode)
Me> (lights! #t) ; just making sure
=> 'explode
```

Boom! What happened? Wasn't `lights!` supposed to be idempotent? Yes,
and it still is. But wait, **I thought that idempotency means that any
idempotent operation should work the same if repeated later!**

&lt;blink&gt;&lt;huge&gt;Nope.&lt;/huge&gt;&lt;/blink&gt;

Let's go back to wikipedia entry and scroll a bit down:

> A composition of idempotent methods or subroutines, however, is not
  necessarily idempotent if a later method in the sequence changes a
  value that an earlier method depends on – idempotence is not closed
  under composition.

*"Not closed under composition"*. Technically, when you call a
function (method, procedure, script, whatever) in a real-world
situation its result is a composition of the current system state,
inputs you provided and the function implementation
itself. Idempotency guarantees that any changes to the system state by
the idempotent operation are such that calling the same operation with
the *updated system state* will result in the same final result as
calling with the *unaltered* system state.

What it does **not guarantee** is that if you call with **some other**
system state you would get the same results. If **anyone else** has
changed the system state between **your** calls to the idempotent
routine, then the system state **has changed** and there are **no
guarantees** that the result from your call will be the same. This is
exactly what happened, Elsie changed the system state, so even though
the `lights` and `lights!` functions are still idempotent, *my*
operations from *my* viewpoint are *not* since the two calls were
composed differently.

At this point you should realize that when standards talk about
[idempotency](https://svn.tools.ietf.org/svn/wg/httpbis/draft-ietf-httpbis/25/p2-semantics.html#idempotent.methods)
or behavior of repeated
[PUTs](https://svn.tools.ietf.org/svn/wg/httpbis/draft-ietf-httpbis/25/p2-semantics.html#PUT)
they are *not* guaranteeing you that all your PUTs will give the same
response or have the same effect in the system every time under all
conditions. What the operation idempotency guarantee can give you is
that when the composition of your PUT has *not changed* (apart from
the changes the *original* PUT made), subsequent PUTs should give you
the same result. But only when that assumption holds, otherwise we
*are not talking about idempotency at all*.

### PUT doesn't have to create resources

The normal life cycle of any object, entity or resource within
computer systems is:

  1. It does not exist.
  2. It is created.
  3. Stuff happens to it.
  4. It is destroyed.
  5. It is no more.

Interpretation of `POST` and `DELETE` operations are straightforward
if you think of them as steps \#2 and \#4 respectively. They manage the
life cycle of the resource. The resource exists between creation and
destruction, and otherwise exists not.

If we take the viewpoint that these are the **only** operations to
manage a resource's lifecycle — and I urge you to take this viewpoint
too — then **`PUT` is valid only during step \#3**.

That is, `PUT` **should not** create a resource.

Now I can already hear an argument in the line of "but using PUT to
create new resources *is* an idempotent operation" and you are
right. If you define PUT to create non-existent resource and update an
existing resource, then two sequential PUTs will always get the same
result (even if the resource didn't exist in the first place). But
this is circular reasoning. You can't argument that PUT should be a
**life cycle operation** because it **can be** one while staying
idempotent. We can define that PUT is **not a life cycle operation**
and it still stays an idempotent operation (PUT on non-existent
resource would result in the same result both times – a failure).

At this point it should be clear that saying that "PUT should create
resources because of idempotency" is a strawman argument because
idempotency holds even if this is not the case.

Which way PUT swings is a design choice. A choice.

I want to convince you that it should **not** create resources.

### PUTs on DELETEd resources

Now I'll try to convince you why `PUT` as a life cycle operation is
not a good idea from developer's perspective because it just causes
practical implementation problems (and if you are not aware of these,
it can create hidden semantic traps in your system).

This is a real-world case (simplified though):

1. User 1 creates a message (POST).
2. User 1 edits the message (GET, PUT).
3. User 2 sees the message and decides to open it for editing (GET).
4. User 1 decides the message is crap and removes it (GET, DELETE).
5. User 2 updates the message (PUT).

If you allow `PUT` to implicitly create non-existent resources, you
get what I'd call *semantically inconsistent result*. For users, the
message exists when it should not. This is entirely consistent from
system's point of view, since the message created at step \#5 is not
the same message that was deleted at \#3.

Unfortunately most of the systems that are written are meant for
*human* consumption and need to work with *human expectations*. Thus
in this case the implicit `PUT` most definitely was *definitely not
helping* system development at all.

Oh no, wait! Here's another!

1. User 1 has CREATE permission on messages.
2. User 2 has EDIT permission on messages.
3. User 3 has REMOVE permission on messages.

I think you can already guess where this is going. If there's implicit
create on PUT I have to check for CREATE permission in two different
places, both `POST` and `PUT`. (This is another real-world scenario
where some people can CREATE and EDIT, others can only EDIT and some
DELETE **but not** create or edit. Auditability requirements...)

### What then is PUT?

Simple:

* It is *idempotent*. (See [above](#idempotency) on limits.)
* It operates on *existing* resources.
* It is **not a life cycle operation**. It cannot create or destroy
  resources.

Idempotent `PUT` still stays the very same and very powerful and
useful feature as before as it allows you to just repeat the request
in case of transient network or server failures. Just please don't
think `PUT` as a life cycle management operation, because it should
not be.
