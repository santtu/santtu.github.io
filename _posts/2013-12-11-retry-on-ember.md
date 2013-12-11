---
layout: post
title: "Ember - (A)bort, (R)etry, (F)ail? R"
tagline: "Another go"
tags: ["rest", "web", "emberjs", "django"]
---

[Earlier]({% post_url 2013-12-04-rest-mess %}) I wrote about problems
I had while trying to develop an [Ember.js](http://emberjs.com)
application with a [Django REST
framework](http://django-rest-framework.org/)-based backend. I did
some research (I'll get back to other results from that later) and
tried using [AngularJS](http://angularjs.org/) for browser-side
development, but it didn't work out too well. I checked some other
client-side frameworks but I really, really wanted to have a good
model representation in the browser side code including relations
between models and I couldn't find one that felt right.

Eventually I decided to give it another go with Ember. I had an
earlier semi-static UI mock that I extended using Ember and static
fixtures. Which despite the steep learning curve eventually worked
<strike>great</strike> well enough.

Though I could not postpone the dealing with the backend indefinitely.

I decided to ditch `ember-data-django-rest-adapter` completely, the
main reason that I didn't understand how I should format the backend
response just by looking at the code (and no docs on that,
unfortunately). It might be just the greatest thing since pre-buttered
bread slices, but I just couldn't understand how to get it working
with the backend framework I was using *even* when it is by name
supposed to work with it. Doh.

This is an after-the-fact reconstruction from memory on how I
progressed:

1. Attach a custom adapter based on `DS.JSONAdapter` (e.g. set
   application's `ApplicationAdapter` value ).

2. Try to understand what an adapter does and what a serializer does.

3. Create a custom serializer. Wonder why some of the methods don't
   get called. Realize that should have used `REST*` base classes.

4. Change adapter and serializer to back from `DS.RESTAdapter` and
   `DS.RESTSerializer` correspondigly.

5. Hack hack hack ...

Eventually I got an adapter and a serializer with only a small number
of minor changes compared to the original `DS.REST*` versions:

* Custom `extractSingle` and `extractArray` methods (which are called
  indirectly by `DS.RESTAdapter.extract`) that don't look for subkeys,
  but use the payload value directly (as a direct value map, or an
  array of value maps, e.g. `[...]` vs. `{"objects":[...]}`).

* `keyForAttribute` and `keyForRelationship` which turn Ember Data
  convention camelcase field names into underscored JSON data keys
  (from `instanceId` to `instance_id`).

* `pathForType` that doesn't do pluralization of resource name
  (e.g. `project` resource list is at `/project` and individual
  resource at `/project/1`).

  (I still have to find a way to include the trailing slash in
  requests, Ember Data seems to be stripping them away, what causes
  extra redirects with Django REST framework. Or just specify
  [`trailing_slash=False`](http://django-rest-framework.org/api-guide/routers#simplerouter)
  for the API router.)

And that's it. Total size is about 20 LOC. I'm pretty surprised about
that the minimal changes needed over `DS.REST*` classes. What I **have
not** done is saving models to the backend — the code might be missing
functionality to make that possible.

You can check the code out yourself at
[github](https://github.com/santtu/freezr). At the moment the
client-side UI code is in
[`freezr/ui/static/freezr_ui/coffeescript`](https://github.com/santtu/freezr/tree/master/freezr/ui/static/freezr_ui/coffeescript)
directory.

P.S. I had one major gotcha while doing this. I've documented that one
in an another [blog post]({% post_url 2013-12-11-gotcha-beware-of-bidir-traffic %}).