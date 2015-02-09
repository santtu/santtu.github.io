---
layout: page
title: rnd()
tagline: Blum Blum Shub
permalink: /
description: "This is the personal blog of Santeri Paavolainen, mostly concerned about technology and cloud computing, but contains other random topics as well."
---
{% include JB/setup %}

<div id="recent">
<ul>
{% for post in site.posts limit:3 %}
{% include post_slug %}
{% endfor %}
</ul>
</div>

[{{ site.posts | size | minus:3 }} more posts →](#posts)

## Who am I?

This is a personal blog of
[Santeri Paavolainen](https://github.com/santtu). As is evident in
what I write about I have a deep interest in software development and
cloud computing. Professionally I work also (probably more) on project
management and strategic technology consulting.

Apart from this blog you can find more about me at these services:

* [github.com/santtu](https://github.com/santtu)
* [twitter.com/paavolainen](https://twitter.com/paavolainen)
* [linkedin.com/in/paavolainen](http://fi.linkedin.com/in/paavolainen)
* [santtu@iki.fi](email:santtu@iki.fi)

I do independent consulting on cloud computing at both strategic
business level ("why and how") and engineering level ("what and
when"). If you are interested in the benefits I can provide for your
organization, [please do be in touch](email:santtu@iki.fi).

## <a name="posts"></a>Posts

<ul class="posts">
  {% for post in site.posts %}
    <li><span style="display: inline-block; min-width: 11.2ex;">{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
