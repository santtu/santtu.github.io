---
layout: post
title: "Freezing Travis"
tagline: "Automated testing for those with frozen feet"
tags: ["ci", "travis"]
---

This is just a quickie. While working on
[freezr](https://github.com/santtu/freezr) I decided to take a look at
[Travis CI](https://travis-ci.org/), which is a *"hosted continuous
integration service for the open source community"* (as they say).

And wow, is it easy. It is.

In just a few lines of `.travis.yml` and some clickety-clackety of
enabling github hooks to travis made all of new code to be
automatically tested in travis. Being free of charge for open source
projects just makes it doubly good!

(Which reminds me, I'll have to attach the OSI-approved license to
freezr. It is open source, but I haven't just gotten around to writing the boring licensing stuff…)

There was … well. Why am I always getting a **gotcha** moment? Am I
just somehow abnormally suspectible to finding corner cases?

Anyway, here's the `.travis.yml` file:

```yaml
language: python
python:
  - "2.7"
env:
  global:
    - PATH=$PATH:$TRAVIS_BUILD_DIR/node_modules/.bin
install:
  - npm install less coffee-script
  - pip install .
services:
  - rabbitmq
script:
  - make actual-test
```

The gotcha is getting node's local install bin directory into `PATH`
environmental variable. Travis by default **does have**
`./node_modules/.bin` in `PATH` so **unless** you change the current
working directory you have no problems in running npm-installed
programs.

(Of course *I did change the working directory* during tests.)

So if you do `npm install` in Travis, keep in mind that **by default
the non-global NPM install bin directory is not necessarily found via
`PATH`**. That it works by default is a happy coincidence, not a
guarantee.

(I could do `sudo npm install -g`, but I try to avoid changing global
system state unless absolutely necessary.)