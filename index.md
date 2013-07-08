---
layout: page
title: n/a
tagline: rnd()
---
{% include JB/setup %}


This is an experimental blog by [Santeri
Paavolainen](https://github.com/santtu). You can find a bit more
information on what I mean by "experimental" in [here](xxx).

## Posts

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
