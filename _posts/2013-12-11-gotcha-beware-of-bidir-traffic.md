---
layout: post
title: "Gotcha!"
tagline: "Beware of bidirectional traffic"
tags: ["emberjs"]
---

> (Note: The code examples below use
  [coffeescript](http://coffeescript.org/) instead of plain
  javascript. If you don't know coffeescript here's a quick cheat
  sheet: `@foo` ≅ `this.foo` and `() -> stmt` ≅ `function () { stmt
  }`. Additionally text in curly braces `{% raw %}{{…}}{% endraw %}` is Ember's
  [templating
  language](http://emberjs.com/guides/templates/handlebars-basics/).)

<figure>
<img style="width: 45%;" alt="Finnish road sign #122" src="http://upload.wikimedia.org/wikipedia/commons/a/a4/Finland_road_sign_122.svg">
<figcaption>Finnish road sign number 122, "Two-way traffic". (Source:
<a
href="http://commons.wikimedia.org/wiki/File:Kaksisuuntainen_liikenne_122.svg">Wikimedia
Commons</a>)
</figcaption>
</figure>

While [doing a retry on Ember]({% post_url 2013-12-11-retry-on-ember %}) for freezr user interface, I hit a
problem I'd like to share with you. I didn't find help on the internet
on this so I hope if someone hits the same problem this post will
help.

Anyway, I hit one major gotcha that had me scratching my head for a
long time. I had used
[ember-time](https://github.com/jgwhite/ember-time) as a basis on how
to implement a "since state change" time display. Converting the
original code to coffeescript was straightforward (but see
[below](#update) for an update):

~~~ coffee
App.FromNowView = Ember.View.extend
  nextTick: null
  tagName: 'time'
  template: Ember.Handlebars.compile '{% raw %}{{view.output}}{% endraw %}'
  output: (() -> (moment @get('value')).fromNow(true)).property('value')
  tick: () ->
    @nextTick = Ember.run.later this, (() ->
      @notifyPropertyChange('value')
      @tick()), 1000
  willDestroyElement: () ->
    Ember.run.cancel @nextTick
  didInsertElement: () -> @tick()
~~~

and it was used like this:

~~~ html
{% raw %}{{view "App.FromNowView" valueBinding="stateUpdated"}}{% endraw %}
~~~

Which worked great when the page was first loaded but **it failed to
update the time view after updates**. I was really really
confused. The `state` value was itself updated in the rendered view
correctly immediately after `Project.reload()` finished, but text
derived from `stateUpdated` field was not. **WTF??** This is what was
happening in the browser:

![How it looked]({{site.url}}/assets/posts/ember-binding-problem-problem-visual.png)

Top row is what happened in the UI and the bottom ones showing what
the server actually sent to the client on state change from running to
freezing to frozen states. Why is it stuck on "for 4 hours"?

Time to debug. So,

* I checked the JSON response. Yep, it had the correct, updated value.

* I wondered whether the name was somehow conflicting (it was
  originally `stateChanged`), so I renamed the JSON field and model
  field. No effect.

* I put tons of log output statements in Ember end Ember Data
  code. This was a great learning experience in itself, as now I have
  a lot better understanding how Ember propagates value changes. Nice
  stuff, I think. However digging deeper and deeper I kept seeing that
  the *updated* value was being passed correctly along, yet still
  refusing to show up in the actual web page.

* I wondered whether the date attribute type was doing something fishy
  and switched to string instead. No effect, the "bad" value
  persisted.

* I searched the net high and low to no avail.

I started to do voodoo coding. Poking at things and hoping the problem
is mysteriously fixed.

Finally I added logging to `DS.attr`'s use of `Ember.computed` and …

<div style="font-size: 300%; margin: 1em 0;">
… all was made clear to me.
</div>

 All of the *other fields* were getting the value
from `@_data` element (which contained the updated values set by
`DS.Model.setupData`) *except* — **except** for `stateUpdated` which
got its value from `@_attributes`!

At this moment I remembered what I earlier read about [Ember
bindings](http://emberjs.com/api/classes/Ember.Binding.html). And that
there was a difference between *normal bindings* and *one-way
bindings*. And that the `valueBinding="stateUpdated"` did a binding on
`App.FromNowView.value` to `Project.stateUpdated`. And that this was a
normal e.g. *two-way binding* meaning that updates on
`Project.stateUpdated` are propagated to `App.FromNowView.value` **and
vice versa**.

I was not getting the updated value from JSON response because **I had
already overwritten it myself**.

This is the offending line:

~~~ coffee
@notifyPropertyChange('value')
~~~

This doesn't actually change the value of `value`, but Ember doesn't
know that so it propagates the event to the bound field of
`Project.stateUpdated`, which eventually results in
`Project.set('stateUpdated', «value»)` where the new value was
actually the old value. I'll try to put this into a picture.

In the figure below I've used <span style="color: white; background:
green;">green</span> for events initiated by Ember Data and <span
style="color: white; background: red;">red</span> for those initiated
by `App.FromNowView` and the gray arrows show bindings between
different Ember-controlled values. I refer to objects by their class
names, so `Project.stateUpdated` below is *not* a class field but a
field in an instance of `Project` class.

![How it worked incorrectly]({{site.url}}/assets/posts/ember-binding-problem-explanation-1.svg)

In the template the statement `valueBinding="stateUpdated"` creates
the two-way fat gray arrow binding (top row). The binding from
`App.FromNowView.value` to `App.FromNowView.output` is a one-way
binding and comes from the use of `property('value')` on the `output`
function (right column). Finally the `App.FromNowView.output` binding
to `{% raw %}{{view.output}}{% endraw %}` comes from somewhere deep
inside the templating system (bottom row).

The initial value is loaded by Ember Data and is propagated from top
left corner by the green arrows. First, `Project.stateUpdated` is
changed, which then propagates to `App.FromNowView.value`, which in
turn causes the value of `App.FromNowView.output` to change, which
finally causes the `{% raw %}{{view.output}}{% endraw %}` template to
be (re-)rendered. This will in turn cause the `get` chain to propagate
back in the chain, finally resulting in the nicely formatted time
delta value to be written into the HTML page for user to see.

This is where the call to `tick` messes things up. It will be called
every second, and it will call `notifyPropertyChange('value')` which
in turn causes **two** propagations to occur — one back to the
**original** `Project.stateUpdated` value thus **overwriting it**, and
the other to propagate to the output template. This meant that the
output value was correctly updated as time passed, but any change in
the actual `stateUpdated` value as reported by the backend was **not**
reflected in the human-readable output.

<small>(I'm not sure, but I think Ember's idea is that since I've
overwritten the values myself it will keep them around until I call
either `save` or `rollback`. I'm not sure whether it is sensible to
call `reload` at all when you have uncommited changes in the
model.)</small>

Now that I had understood the true problem the solution came
immediately. In the application I just wanted to ensure that updates
on the bound value are propagated to `App.FromNowView.output`, which
was already automatically updating when the bound value was
changed. It also has to be refreshed as time progresses ("a few
seconds" → "a minute") which *does not* need to refresh the bound
value, just the *output value*. The correct update sequence where
*display updates* do not affect the actual state update time value is
shown in the picture below:

![How it works correctly]({{site.url}}/assets/posts/ember-binding-problem-explanation-2.svg)

Now `tick` will only cause the **rendered** value to be updated while
all changes in the original model are **also** honored. The change is
trivially simple with changing the property change event fired on the
*output* element:

~~~ coffee
tick: () ->
  @nextTick = Ember.run.later this, (() ->
    @notifyPropertyChange('output')
    @tick()), 1000
~~~

With this simple change everything was finally made good!

So what's the lesson learned? When using Ember, *you need to
understand how a value is bound, to where, and what type of binding
makes sense for any particular situation*. Also don't use
`@notifyPropertyChange` indiscriminantly on values that are bound
*from outside the caller's control*.

<a name="update"></a>**Update:** Ember-time itself has since been fixed.  You'll need to
look at
[bf3383c6](https://github.com/jgwhite/ember-time/tree/bf3383c691bd7f60aafb96ddd7926be3196f1dfd)
or earlier commit to see the original version.
