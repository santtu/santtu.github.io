---
layout: post
title: "My old flame ... from 17 years past"
tagline: "Also: Why you should not be using mine or anybody's MD5 hash implementation"
tags: ["programming", "java", "md5", "crypto"]
---

Before I get about talking old stuff, here's a few **important**
suggestions for anyone who came here looking for my old MD5 Java
implementation (in case you don't know, MD5 is a [cryptographic hash
function](http://en.wikipedia.org/wiki/Cryptographic_hash_function)):

* Firstly, **do not use it.** There are plenty of good alternatives starting
    from Java's standard library's
    [`java.security.MessageDigest`](http://docs.oracle.com/javase/7/docs/api/java/security/MessageDigest.html)
    up to separate open-source implementations such as
    [`org.bouncycastle.crypto.digests.MD5Digest`](http://www.bouncycastle.org/docs/docs1.5on/org/bouncycastle/crypto/digests/MD5Digest.html).

* Secondly, **do not use MD5 at all.** MD5 has not been considered
  secure enough for new applications for over a decade now. Use SHA256
  or better instead. It's of course another issue if you're working
  with legacy protocols, but for any **new** implementation you just
  **do not use MD5**.

* Thirdly, if you are planning to do what seems to be every new web
  site programmers thing, that is, when you've come to realize that
  storing plaintext passwords is **bad** and have come up with the
  idea of storing passwords as hashes, and were thinking of using MD5
  for that — and of course now you'd be thinking of SHA256 instead —
  **do not use a cryptographic hash function for password
  hashing**. Use a hash function *specifically designed for long-term
  secure password hash storage* such as
  [PBKDF2](http://en.wikipedia.org/wiki/PBKDF2). Just don't use a
  plain hash function for password hashing. Trust me.

* And of course if all of the above is new news for you, **please
  please please** get some education. I **pathologically hate closet
  cryptographers** e.g. people who think they know everything about
  cryptography since they've finally succeeded in breaking out of a
  wet paper bag.

The reason for this post is that I still keep getting e-mails for
support and questions about an MD5 Java implementation I wrote a
*looooooong* time ago (1996). It is so long time ago that in a few
years people starting their professional programming careers will be
*younger* than that piece of code.

(Oh boy, am I old.)

So if you have come here to report a bug in my MD5 implementation or
have a question about how to use it, now you have the full story why
it is effectively abandonware (which it sort of isn't, since it is
under LGPL and has thus been incorporated to many other codebases) —
and that it is usable in *and relevant* to only a very narrow set of
programming problems, which *yours most likely is not one of them*.

I don't even have the source online anymore. I find keeping it online
pointless for the reasons listed above. If you are super-interested in
the source, just search for [`md5
paavolainen`](https://www.google.com/search?q=md5+paavolainen),
although a lot of the hits are actually derived (mostly better!)
implementations.

Why did I write an MD5 Java implementation in the first place?

<small>(Imagine the following spoken with a hoarse, oldtimer voice,
worn rough by the dust inhaled by years in solitude service among
racks and racks of ancient servers.)</small>

Well, this happened in 1996 when Java was still at version 1.0.2 and
did not have `java.security` package at all (it came along in 1997). I
just needed MD5 in a browser Java applet for the purpose of signing a
request sent to backend server (implemented in C as a module to CERN
httpd, oh the times) on a research project into micropayments. I
didn't find a ready-to-use MD5 Java class (the Internet was much
smaller back then) so I wrote one following almost 1:1 the RSA
C-language reference implementation. (The micropayment project never
got anywhere practical, but that's a whole another story...)

<small>(Back to normal voice.)</small>

<br/>

P.S. I'm not saying that I'm offended by people e-mailing me about the
MD5 class — on the contrary, it does feel good to know you have made -
albeit very small - but a lasting contribution to the "great internet
of buzzwords". What I sincerely hope for is that those e-mail would
stop, not because I don't like them, but because MD5 in general, and
definitely not my unmaintained implementation of it *should not be
used anymore*. Move along, don't dwell in the cryptographic past.

P.P.S. I'll be more positive on the next post, I promise.