---
title: Life is short, why URLs long?
tagline: Yeah, something broke ...
tags: ["scala", "scala.js", "chrome"]
---

At the end of last year, I wrote as part of a thesis work an [energy
market simulator]({% post_url 2018-01-10-energy-simulator %}) modeling
the Finnish electricity market. While I moved onward after finishing
that work, I've been intending to return to the project to fix a few
of the nagging TODO items.

So, while taking a look at that I also noticed that copy-pasting URLs
from the simulator did not work anymore. Ouch!

But why is this a problem? The simulator has a few interesting
implementation details:

* It runs completely in the browser --- the Monte Carlo simulation
  runs as a web worker in the browser.
* It is written in Scala (not JavaScript). Actually, it uses Scala.JS
  which generates JavaScript from Scala sourcecode (while being mostly
  cross-compilable to JVM too).
* There is **no backend and thus no state stored in any backend**.
* All of the simulation world state (those user can manipulate) is
  **encoded in the URL**.

The last one is intended to make two things possible:

* If you do modifications on the world state and bookmark the page,
  then loading the bookmark will get you the **modified** world and
  not the default one.
* You can share the URLs, as opening the URL will get the same world
  state as you had.

## Something broke

> I have been exclusively testing this on Chrome and I do not make any
> claims or attempts about whether the application works on any other
> browser.

Late last year the URL copying worked. When I tested it a few weeks
back, it did not. Something had changed in Chrome. Or OS X. (I checked
Chrome changelogs from last December but could not find anything
immediately obvious.)

Regardless of the cause, I wanted to make URL copying work again.

## Solutions, so many solutions to choose from!

This was a problem I had considered before, and knew the solution to
that already: _encode only changes_ from the default world state. So,
what to use? Since the original (_"version 1"_) data encoding scheme
dumped the whole world state as base64-encoded JSON, a reasonable step
might have been using JSON diffs --- but no, I could not find
reasonable Scala.JS-compatible implementations. Also, many "JSON diffs"
looked quite verbose and might not have actually solved the problem at
all.

Maybe if I encoded the world state as binary JSON (BSON) instead?
Alas, I did not find libraries with sufficient Scala.JS support.

No automated luck this time. Let's roll our own then!

Since the UI only allows users to change the enabled/disabled state
and capacity or sources and lines and they have unique ids, it is
possible to make a short cut and only encode changes from the default
value on an identifier-by-identifier basis. So I wrote a JSON
encoder/decoder wrapper for a class that encapsulates such changes.

So now the default world state URL is small since there are only some
metadata encoded (no changes to encode). Then, toggle all and change
capacities (using the global toggles and sliders) and ... too long
URL. Can't copy paste. _Damn_.

JSON ends up too verbose in this case. Partially this is also due to
the encoder/decoder logic which maps a `case class Change(name:
String, version: Int, changes: Seq[Change])` into `{"name": ...,
"version":, ..., "changes": [...]}` where each change repeats the
`name`, `version` and `changes` strings in verbatim. I could have
changed to encode the changes as an array (`[id,enabled,capacity]`)
but... decided not to.

I decided to go for a binary encoding directly. BSON was not an
option, so what others? [MsgPack](https://msgpack.org/) would have
been nice, since it at least has a specification and some
cross-platform support, but again, I did not find a ScalaJS-compatible
implementation that I was happy with.

There are quite a few binary encoders supporting Scala.JS. Out of
those, I settled on [BooPickle](https://boopickle.suzaku.io/). With
that I got the worst case data encoded as (I've broken it to lines of
80 characters, in reality this is all a single unbroken string):

```
#2-AAVTdW9taQFTAApjZW50ZXItb2lsAgACgJwADmNlbnRlci1vaWwtY2hwAgABAAtjZW50ZXItd2luZ
AIAAorIAApjZW50ZXItYmlvAgABAA5jZW50ZXItYmlvLWNocAIAAobGAAtjZW50ZXItY29hbAIAAQALY
2VudGVyLXBlYXQCAAKBnQAPY2VudGVyLXBlYXQtY2hwAgACiFAADGNlbnRlci1oeWRybwIAAoXrAA5jZ
W50ZXItbnVjbGVhcgIAAQAKY2VudGVyLWdhcwIAAQAOY2VudGVyLWdhcy1jaHACAAKA-wAMY2VudGVyL
W90aGVyAgABABBjZW50ZXItb3RoZXItY2hwAgACgSsADGNlbnRlci1zb2xhcgIAAQAId2VzdC1vaWwCA
AKDNgAMd2VzdC1vaWwtY2hwAgACTAAJd2VzdC13aW5kAgACiQUACHdlc3QtYmlvAgABAAx3ZXN0LWJpb
y1jaHACAAKCTQAJd2VzdC1jb2FsAgAChhYADXdlc3QtY29hbC1jaHACAAKH-wAJd2VzdC1wZWF0AgABA
A13ZXN0LXBlYXQtY2hwAgAChOsACndlc3QtaHlkcm8CAAKHjQAMd2VzdC1udWNsZWFyAgACoCCsAAh3Z
XN0LWdhcwIAAQAMd2VzdC1nYXMtY2hwAgAChYMACndlc3Qtb3RoZXICAAEADndlc3Qtb3RoZXItY2hwA
gACgIAACndlc3Qtc29sYXICAAIOAAlub3J0aC1vaWwCAAIhAApub3J0aC13aW5kAgACi2AACW5vcnRoL
WJpbwIAAQANbm9ydGgtYmlvLWNocAIAAoN4AApub3J0aC1jb2FsAgABAApub3J0aC1wZWF0AgABAA5ub
3J0aC1wZWF0LWNocAIAAoPJAAtub3J0aC1oeWRybwIAAqAfjwANbm9ydGgtbnVjbGVhcgIAAQAJbm9yd
GgtZ2FzAgABAAtub3J0aC1vdGhlcgIAAQALbm9ydGgtc29sYXICAAEACXNvdXRoLW9pbAIAAoLlAApzb
3V0aC13aW5kAgACgQ4ACXNvdXRoLWJpbwIAAQANc291dGgtYmlvLWNocAIAAoZGAApzb3V0aC1jb2FsA
gABAA5zb3V0aC1jb2FsLWNocAIAAqAQSAAKc291dGgtcGVhdAIAAQAOc291dGgtcGVhdC1jaHACAAKBR
wALc291dGgtaHlkcm8CAAKEHgANc291dGgtbnVjbGVhcgIAAqASuwAJc291dGgtZ2FzAgABAA1zb3V0a
C1nYXMtY2hwAgACjkIAC3NvdXRoLW90aGVyAgABAA9zb3V0aC1vdGhlci1jaHACAAKCKwALc291dGgtc
29sYXICAAITAAhlYXN0LW9pbAIAAoMLAAllYXN0LXdpbmQCAAJjAAhlYXN0LWJpbwIAAQAMZWFzdC1ia
W8tY2hwAgAChnAACWVhc3QtY29hbAIAAQAJZWFzdC1wZWF0AgABAA1lYXN0LXBlYXQtY2hwAgACg-oAC
mVhc3QtaHlkcm8CAAKG9QAMZWFzdC1udWNsZWFyAgABAAhlYXN0LWdhcwIAAQAMZWFzdC1nYXMtY2hwA
gACIQAKZWFzdC1vdGhlcgIAAQAOZWFzdC1vdGhlci1jaHACAAJ2AAplYXN0LXNvbGFyAgABAAp3ZXN0L
XNvdXRoAQKgNB0AC3dlc3QtY2VudGVyAQKgNB0ACnNvdXRoLWVhc3QBAqA0HQAMc291dGgtY2VudGVyA
QKgNB0AC2Vhc3QtY2VudGVyAQKgNB0ADGNlbnRlci1ub3J0aAECoDQdABNzd2VkZW4tbm9ydGgtaW1wb
3J0AQKH0AASc3dlZGVuLXdlc3QtaW1wb3J0AQKGQAAScnVzc2lhLWVhc3QtaW1wb3J0AQKGxQATbm9yd
2F5LW5vcnRoLWltcG9ydAECgIQAFGVzdG9uaWEtc291dGgtaW1wb3J0AQKFNQ==
```

That's 1950 characters. Not bad! That actually we can copy and
paste. (That's also what is a "version 2" of the data format.)

Yet it is possible to do much, much better. Here is the same URL
encoded in "version 3" format:

```
#3-AAVTdW9taQFTCAIAAoCcCQIAAQ8CAAKKyAACAAEBAgAChsYCAgABDAIAAoGdDQIAAohQBQIAAoXrB
wIAAQMCAAEEAgACgPsKAgABCwIAAoErDgIAAU8CAAKDNlACAAJMVwIAAokFRgIAAUcCAAKCTUkCAAKGF
koCAAKH-1MCAAFUAgAChOtNAgACh41OAgACoCCsSwIAAUwCAAKFg1ECAAFSAgACgIBVAgACDicCAAIhL
AIAAotgIQIAASICAAKDeCMCAAEpAgABKgIAAoPJJQIAAqAfjyYCAAEkAgABKAIAASsCAAE7AgACguVBA
gACgQ4xAgABMgIAAoZGNAIAATUCAAKgEEg-AgABPwIAAoFHOQIAAoQeOgIAAqASuzcCAAE4AgACjkI8A
gABPQIAAoIrQAIAAhMYAgACgwseAgACYxACAAERAgAChnATAgABGwIAARwCAAKD6hYCAAKG9RcCAAEUA
gABFQIAAiEZAgABGgIAAnYdAgABVgECoDQdSAECoDQdNgECoDQdMwECoDQdEgECoDQdBgECoDQdQgECh
9BEAQKGQC8BAobFLQECgIQfAQKFNQ==
```

Only 591 characters! Yet it encodes exactly the same information. How
is that possible?

The world data is named and versioned with the assumption that any
structural change will result in a new version number. This means that
all source and line identifiers in the model are static and sorting
the identifiers will result in a sequence where a particular
identifier will stay at the same index! The version 3 data format uses
this fact to turn identifier into integers. This helps a lot since the
identifiers are actually pretty long (descriptive) strings.

I kept support for the older formats in the code, so if you had a
version 1 encoded URL and can get your browser to open it, it should
still work. Similarly you can try to open [this
URL](http://energysim.kooma.net/#2-AAVTdW9taQFTAApjZW50ZXItb2lsAgACgJwADmNlbnRlci1vaWwtY2hwAgABAAtjZW50ZXItd2luZAIAAorIAApjZW50ZXItYmlvAgABAA5jZW50ZXItYmlvLWNocAIAAobGAAtjZW50ZXItY29hbAIAAQALY2VudGVyLXBlYXQCAAKBnQAPY2VudGVyLXBlYXQtY2hwAgACiFAADGNlbnRlci1oeWRybwIAAoXrAA5jZW50ZXItbnVjbGVhcgIAAQAKY2VudGVyLWdhcwIAAQAOY2VudGVyLWdhcy1jaHACAAKA-wAMY2VudGVyLW90aGVyAgABABBjZW50ZXItb3RoZXItY2hwAgACgSsADGNlbnRlci1zb2xhcgIAAQAId2VzdC1vaWwCAAKDNgAMd2VzdC1vaWwtY2hwAgACTAAJd2VzdC13aW5kAgACiQUACHdlc3QtYmlvAgABAAx3ZXN0LWJpby1jaHACAAKCTQAJd2VzdC1jb2FsAgAChhYADXdlc3QtY29hbC1jaHACAAKH-wAJd2VzdC1wZWF0AgABAA13ZXN0LXBlYXQtY2hwAgAChOsACndlc3QtaHlkcm8CAAKHjQAMd2VzdC1udWNsZWFyAgACoCCsAAh3ZXN0LWdhcwIAAQAMd2VzdC1nYXMtY2hwAgAChYMACndlc3Qtb3RoZXICAAEADndlc3Qtb3RoZXItY2hwAgACgIAACndlc3Qtc29sYXICAAIOAAlub3J0aC1vaWwCAAIhAApub3J0aC13aW5kAgACi2AACW5vcnRoLWJpbwIAAQANbm9ydGgtYmlvLWNocAIAAoN4AApub3J0aC1jb2FsAgABAApub3J0aC1wZWF0AgABAA5ub3J0aC1wZWF0LWNocAIAAoPJAAtub3J0aC1oeWRybwIAAqAfjwANbm9ydGgtbnVjbGVhcgIAAQAJbm9ydGgtZ2FzAgABAAtub3J0aC1vdGhlcgIAAQALbm9ydGgtc29sYXICAAEACXNvdXRoLW9pbAIAAoLlAApzb3V0aC13aW5kAgACgQ4ACXNvdXRoLWJpbwIAAQANc291dGgtYmlvLWNocAIAAoZGAApzb3V0aC1jb2FsAgABAA5zb3V0aC1jb2FsLWNocAIAAqAQSAAKc291dGgtcGVhdAIAAQAOc291dGgtcGVhdC1jaHACAAKBRwALc291dGgtaHlkcm8CAAKEHgANc291dGgtbnVjbGVhcgIAAqASuwAJc291dGgtZ2FzAgABAA1zb3V0aC1nYXMtY2hwAgACjkIAC3NvdXRoLW90aGVyAgABAA9zb3V0aC1vdGhlci1jaHACAAKCKwALc291dGgtc29sYXICAAITAAhlYXN0LW9pbAIAAoMLAAllYXN0LXdpbmQCAAJjAAhlYXN0LWJpbwIAAQAMZWFzdC1iaW8tY2hwAgAChnAACWVhc3QtY29hbAIAAQAJZWFzdC1wZWF0AgABAA1lYXN0LXBlYXQtY2hwAgACg-oACmVhc3QtaHlkcm8CAAKG9QAMZWFzdC1udWNsZWFyAgABAAhlYXN0LWdhcwIAAQAMZWFzdC1nYXMtY2hwAgACIQAKZWFzdC1vdGhlcgIAAQAOZWFzdC1vdGhlci1jaHACAAJ2AAplYXN0LXNvbGFyAgABAAp3ZXN0LXNvdXRoAQKgNB0AC3dlc3QtY2VudGVyAQKgNB0ACnNvdXRoLWVhc3QBAqA0HQAMc291dGgtY2VudGVyAQKgNB0AC2Vhc3QtY2VudGVyAQKgNB0ADGNlbnRlci1ub3J0aAECoDQdABNzd2VkZW4tbm9ydGgtaW1wb3J0AQKH0AASc3dlZGVuLXdlc3QtaW1wb3J0AQKGQAAScnVzc2lhLWVhc3QtaW1wb3J0AQKGxQATbm9yd2F5LW5vcnRoLWltcG9ydAECgIQAFGVzdG9uaWEtc291dGgtaW1wb3J0AQKFNQ==). If
you manipulate the model in any way (try toggling a checkbox) it will
convert the URL into version 3 format ([like
this](http://energysim.kooma.net/#3-AAVTdW9taQFTCAIAAoCcCQIAAQ8CAAKKyAACAAEBAgAChsYCAgABDAIAAoGdDQIAAohQBQIAAoXrBwIAAQMCAAEEAgACgPsKAgABCwIAAoErDgIAAU8CAAKDNlACAAJMVwIAAokFRgIAAUcCAAKCTUkCAAKGFkoCAAKH-1MCAAFUAgAChOtNAgACh41OAgACoCCsSwIAAUwCAAKFg1ECAAFSAgACgIBVAgACDicCAAIhLAIAAotgIQIAASICAAKDeCMCAAEpAgABKgIAAoPJJQIAAqAfjyYCAAEkAgABKAIAASsCAAE7AgACguVBAgACgQ4xAgABMgIAAoZGNAIAATUCAAKgEEg-AgABPwIAAoFHOQIAAoQeOgIAAqASuzcCAAE4AgACjkI8AgABPQIAAoIrQAIAAhMYAgACgwseAgACYxACAAERAgAChnATAgABGwIAARwCAAKD6hYCAAKG9RcCAAEUAgABFQIAAiEZAgABGgIAAnYdAgABVgECoDQdSAECoDQdNgECoDQdMwECoDQdEgECoDQdBgECoDQdQgECh9BEAQKGQC8BAobFLQECgIQfAQKFNQ==)).

If you are interested in the code, you can find it
[here](https://github.com/santtu/energysim/blob/8d2daec02d3ffd8e4148cd3e1fda2356c6e0a0c1/ui/src/main/scala/fi/iki/santtu/energysimui/Main.scala#L163)
(I linked a commit version since I might refactor the code later).

P.S. If you are bothered because of inconsistent indentation, it is
caused by me sometimes editing the code in IntelliJ IDEA and sometimes
in Emacs (with ENSIME). I strongly refrain from re-indenting source
files on a whim as it breaks a lot of version history tracking, even
on my own source code. As a professional programmer I have learned a
long time ago to check in my own ego (regarding indentation and code
style) at the door and insead adjust to the style of the codebase
currently being worked on.

So if you are a junior: <span style="color: red">Don't be an
ass</span> --- don't arbitrarily re-style existing code to your own
tastes. Touch only the code you actually work on.
