---
layout: page
title: rnd()
tagline: Blum Blum Shub
permalink: /
description: "This is the personal blog of Santeri Paavolainen, mostly concerned about technology and cloud computing, but contains other random topics as well."
---
{% include JB/setup %}

This is an experimental blog by
[Santeri Paavolainen](https://github.com/santtu). You can find a bit
more information on what I mean by "experimental" in [here]({% post_url 2013-04-12-can-you-blog-in-github %}) and [here]({% post_url 2013-07-08-jekyll-and-hyde %}).

My basic bio:

* [github.com/santtu](https://github.com/santtu)
* [twitter.com/paavolainen](https://twitter.com/paavolainen)
* [linkedin.com/in/paavolainen](http://fi.linkedin.com/in/paavolainen)
* [santtu@iki.fi](email:santtu@iki.fi)

I do independent consulting on cloud computing at both strategic
business level ("why and how") and engineering level ("what and
when"). If you are interested in the benefits I can provide for your
organization, [please be in touch](email:santtu@iki.fi).

## Posts

<ul class="posts">
  {% for post in site.posts %}
    <li><span style="display: inline-block; min-width: 11.2ex;">{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
