---
layout: post
title: "re:Invent — growth pains"
tags: ["aws", "reinvent", "reinvent2018"]
---

This is a just quick post from re:Invent 2018 conference. I am
planning to later write more on how the cloud industry has changed
over the years since my previous visits at the conference.

However, for now I am just going to <strike>bitch</strike>comment on
some practical issues here at re:Invent 2018 and how they relate how
the conference when I visited it the last time in 2012 and 2013.

(This is being finalized on Tuesday, end of *the second day* of the
conference. There are still three days to go.)

## Locations 👎

The move from a single location (Sands Expo) to multiple hotels and
conference venues on the strip is problematic:

* You need to transfer between sites unless you can schedule all of
  your sessions in a single location (for a day) --- the transport
  time varies hugely, I've gotten from Mirage to Aria in 10 minutes
  (morning, light traffic) versus 10 minutes wait time plus 50 minutes
  transport time (Aria to Venetian) with queues, full buses, and
  an accident clogging the rush-hour congested route.

* Given that popular sessions will be full, **not being at the
  entrance** 10 minutes prior to the session can mean complete miss of
  that session --- definitely frustrating if you missed because of
  transport delays. If you had a reserved seat, they expire at 10
  minutes prior to the session start, so that's sort of a double loss
  --- you made the effort to reserve a seat, then lost the whole
  session.

* The logistics of planning which sessions and where to attend is just
  ... the conference app and web site do not help, either. (I wrote [a
  screen scraper](https://github.com/santtu/reinvent2ics) solely to
  generate an ICS file from the planner's "interests" just to be able
  to import them to Google Calendar for easier schedule
  management. The fact that the planner app needs wifi to show your
  schedule is a back-ass-ward design. Ever heard of offline use? Like,
  using AWS's own mobile services and toolkits?)

Nevertheless, I found that *not having a registered seat* is not a
huge problem --- you'd need to be there 10 minutes in advance
regardless of whether you have a reservation or not. I've managed to
get into all sessions so far (I'm sure this streak won't last, though)
where I've been at the door 15 minutes prior as a walk-up (no seat
registration) attendee. (Which reminds me, that as of writing this,
I've got next session chalked up in 18 minutes, need to get to the
queue to see if my 15-minute experience still holds.)

## Crowd 🤷

I have not heard of any official statement on number of attendees, but
**this conference is crowded**, at least in Venetian and Aria (the
main sites). It's not yet elbow-in-your-mouth-crowded, but I've seen a
lot of lock-step marching in and out of places, bottleneck routes
getting really congested.

So, not as terrible to make me skip sessions or venues, but definitely
more crowded venues --- even with people spread over multiple
locations --- than in 2012/13.

The other consequence is that **you are extremely unlikely to run into
a specific person without explicit arrangements** --- I am pretty sure
I met 80% of all Finnish attendees in those earlier
conferences. While, in general, conferences are bad places of
"*trying* to meet someone", I find the extremely unlikelihood of such
accidental meets (of people I know are here) somehow distancing,
making me feel more detached from others.

## Wifi 😢

Between absolutely horrible to passable. Superbly frustrating when you
can ping 8.8.8.8, but nothing else seems to pass through to the
Internet.

Since I don't have a local SIM --- and did not pay for the 2 GB
USA-specific package from my home operator --- I can't even fall back
to mobile data.

Which brings me back to this:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en"
dir="ltr">Hey <a
href="https://twitter.com/AWSreInvent?ref_src=twsrc%5Etfw">@AWSreInvent</a>,
imagine the following scenario:<br><br>1) go to registration<br>2)
open app for QR code<br>3) app requires re-login<br>4) login requires
net<br>5) wifi password in app<br>6) no data roaming ($$$/MB for
non-US SIM)<br><br>Wifi pwd prominently++, plz?<br><br>(Registration
painless w/o QR though.)</p>&mdash; Santeri Paavolainen (@paavolainen)
<a
href="https://twitter.com/paavolainen/status/1066890425737375744?ref_src=twsrc%5Etfw">26. marraskuuta
2018</a>
</blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Catch-22.

## Length 🤔

I think --- again, based on my memory, too <strike>lazy</strike>tired
to check --- the earlier ones were three days plus a half day for
partner summit. This is a bit of a ±0 thing as more days = more
content, but also more days = more difficult to schedule such a long
trip. This trip eats two whole weekends for traveling here and back.

## Improvements 🙋

Not all is meh. There are some things that I see as improvements over
my previous visits, and some things that I've heard from attendees as
improved from last year.

* Lots of guides and helpers --- not sure where is something? There's
  practically **all the time** literally a highly visible guide within
  20 paces of you. While the number of staff seems excessive at times,
  they are definitely helpful and useful. I realized I've come to
  realize almost completely on them instead of even trying to check
  the venue map on the flaky wifi.

* Better transport than last year. I wasn't here last year, but people
  who were said it was absolutely horrible last year. I understood
  that last year the shuttle buses were doing a circular route over
  all the locations --- and this year they were point-to-point.

* Overflows. These are screen-and-wireless-headphones combination in
  most (all?) locations. Some sessions are marked as OVERFLOW and
  these can be viewed from any of these overflow locations. (I don't
  get the terminology though. Overflow in different location? Overflow
  to?)

  I only today realized how useful this was when instead of trying to
  go to a session and *then* jump on a shuttle to next location, I
  could do the other way around and use the overflow at the *other*
  location to watch the session at the place where I just left!
  Doesn't maybe make sense initially, but when you factor in lunch,
  travel time etc. it ended up being much easier this way.

## Overall

Almost all people I discussed about the size of the conference agreed
that re:Invent is too big, multiple venues is pain and so on. This
included several AWS staff, too.

How to fix? AWS Summits are clearly a way forward, maybe they could be
developed and promoted further, turn them from one-day events to
two-day events? Have them more frequently in a geographical location,
so there would be no incentive to attend *every* one of nearby ones?

Move re:Invent to another, more compact location?

Make all sessions remotely viewable live? Live for a fee, some time
later free. You've already got overflows, which are live, so the
capability is there. (Maybe overflows are a PoC?)

Split re:Invent into differently focused conferences? While a large
portion of the services are generic and useful in different
situations, I can imagine it would be possible to create some
differentiations that could act as a divider. Enterprise (migrations,
governance, services more relevant to enterprises, etc. etc.)
vs. technology focus (less governance, more startup-ey)?

I don't know. This is not purely a logistical problem, these big
conferences (just think of Microsoft and Apple) serve also other goals
than just <strike>wine and dine</strike> <strike>entertain</strike>
educate the attendees.

(I planned this to be a short post. Better stop right n

<br/>
<br/>

----

(You can see all posts from re:Invent 2018 hunting down the
[reinvent2018](/tags.html#reinvent2018-ref) tag.)
