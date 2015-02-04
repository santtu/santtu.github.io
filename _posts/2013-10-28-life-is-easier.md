---
layout: post
title: "Life's easier if you can code"
tagline: Even if it is just excel formulas and mail merge
tags: ["programming", "code", "python"]
---

If you have never ever programmed anything, you can find the title of
this post strange. Are programmers somehow superhuman, capable of
lifting railroad cars with their bare hands? Are they more
intelligent, more capable than other people? Or is there a secret
cabal of programmers where by joining you'll get secret discounts at
electronics stores and easier promotions at work?

Oh I just wish even just the second to last would be true, but alas,
none of the above.

Being a programmer does not make you fitter (strangely often the
opposite), nor stronger. But it does help quite a lot in many
things. It's also possible to do some [really cool
things](http://www.youtube.com/watch?v=ukpBk3vvue8) if you mix in with
some physical world stuff with the programming. However that's not the
kind of "making life easier" stuff I'm really talking about.

----

I was inspired to write this post because I'm trying to sell some
stuff, mostly old magazines boxed up (why I have kept them in the
first place, though?). There's a nice free-to-advertise
craigslist-style site used here in Finland that I've used before
*but*. The *but* is there's a length limit on the ad and I've got
*tons* of those magazines to sell. Itemizing them goes over the length
limit many times over.

So what do I do?

I whip up a [Python](http://www.python.org/) script using
[Genshi](http://genshi.edgewall.org/) formatting an
[YAML](http://yaml.org/) input file. The output is a bunch of text
files, broken down by magazine names. Here it is, a total 9 lines of
code:

~~~ python
#!/usr/bin/env python3
import genshi.template, yaml

data = yaml.load(open("data.yaml"))
tmpl = genshi.template.NewTextTemplate(open("template.txt"))
i = 1

for mags in data:
    names = list(map(lambda e: e['name'], mags))
    result = str(tmpl.generate(magazines=mags, names=names))
    print(result, file=open('out/' + (", ".join(names)) + '.txt', 'w'))
    i += 1
~~~

Time spent:

* Script: 10 minutes
* Writing text template: 5 minutes
* Reformatting data to YAML: 30 minutes

Not bad — I did have the magazine data already available (text file,
needing some reformatting for YAML) so this went quite nicely. After
this effort I basically need just to log into the classified site and
copy-paste the data file by file. (If I had really literally tons of
ads to place I'd scripted the uploading part too, but I have just
tens. Not worth optimizing that.)

Eventually I had to reformat the output several times before the site
grokked it. I would hate even the *potential* of having to re-do
something that tedious by hand, so I'm positive about the result.

----

There is great benefit in optimizing repeated tasks (xkcd has a nice
[illustration](http://xkcd.com/1205/) about it). Here I needed the
script only once, so I'm not sure whether I came out ahead time-wise,
but definitely I didn't get to experience the tedium of doing so.

Come to think about it, the reason I did use templating was probably
to *avoid a tedious task* by turning it into a *programming
problem*. Writing a small script to do the task at least gave me a
feeling of *being productive* even if it might not have been so.

Ha! Maybe that's it:

> Being able to write programs makes life easier by allowing you to
> turn (some) tedious tasks into interesting programming problems.

I'm happy with that.

P.S. So what about Excel? I do actually find spreadsheets quite useful
as an miniature programming platforms when the data I'm manipulating
is already in tabular form. Doing `=if($B4<>"";TRUE;FALSE)` and
copy-pasting it over a row is often faster than writing and debugging
an imperative program.
