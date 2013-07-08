---
layout: post
title: "Enter Jekyll (where's Hyde?)"
---

Live and learn. [Earlier]({% post_url 2013-04-12-can-you-blog-in-github %})
I wondered whether I could use a github repository as a place to publish a blog. Essentially my original plan was to use the plain repository view as a way to render ReST formatted pages. But it got a bit unwieldy very fast after that.

* A blog needs a feed. A blog without a feed isn't a blog, at least by
  my definition. So I thought about writing a short script to read the
  page titles from RST files and output an `.atom` and `.rss` formats
  (and wrote one).

* You still need a "master" page for random visitors so they can see
  what you've written lately. Ok, not a biggie either.

* And ... !!!!

**No!** I'm not going that way, **again**. I've written static website
and blog generators before and I know where this path would lead me
to. There has to be a better way! Surely my idea of using github as a
blogging platform, surely there must be programmers who also <abbr
title="Don't Repeat Yourself">DRY</abbr>.

Of course I had seen and heard about
[GitHub Pages](http://pages.github.com/) but had somehow completely
bypassed them earlier. Funny how you can ignore so completely
something you sort of know. I guess if someone had come to me a month
back and asked "You know about github pages?" I'd certainly answered
"Yep, you can host static web sites and blogs there." Somehow I just
didn't make the connection between
[what I was looking for]({% post_url 2013-04-12-can-you-blog-in-github %}) and
[what's available](http://pages.github.com/). C'est la vie.

Alas, github pages isn't a complete solution to your blogging
needs. It does come with [Jekyll](http://jekyllrb.com/) static site
generator which will help a lot in creating a website by either
automating a lot of the legwork or by providing ready-made
abstractions for wrapping custom stuff in Liquid templates.

I took a look at some of the
[example Jekyll-generated sites](https://github.com/mojombo/jekyll/wiki/sites). Some
are very pretty, and I'm impressed by the fact that sites like
[Development Seed](http://developmentseed.org/) can be generated via
Jekyll. (Or maybe I shouldn't. HTML5 makes that very possible. Perhaps
it is more impressive that the site has been made despite problems
that Jekyll has probably created... there's no perfect tool, and I
would assume Development Seed's creators have hit a few gotchas along
the way.)

"But still", I was thinking, "do I have to write all those templates
just to get a working static blog generator?"

So, if you're thinking about creating your blog on GitHub pages using
Jekyll, here's what I found out:
**[Jekyll Bootstrap](http://jekyllbootstrap.com/)**. Quickly, do this!

```
$ sudo gem install jekyll
$ git clone https://github.com/plusjade/jekyll-bootstrap.git USERNAME.github.io
$ cd USERNAME.github.io
$ rake post title="Hello World"
$ jekyll server -w
```

and then browse to `http://localhost:4000`. You'll see an example post
and the one you just created before (*Hello World*). You'll find the
sample post in `_posts` directory. Edit it. Reload the page in
browser. **You can already see results!**

The next step is to push your cloned repository to your own account
under github -- you'll need to 1)
[create the repository](https://github.com/repositories/new), 2)
update repository url at your checked-out Jekyll bootstrap repository
and 3) push.

```
$ git remote set-url origin git@github.com:USERNAME/USERNAME.github.io.git
$ git push origin master
```

Note that `USERNAME` really should be your **own** github username
when you push. Earlier when cloning it was just a directory name, but
in `set-url` it **must** match your github username. *You won't see
your pages in github pages* unless you push to `<your
username>.github.io` repository.

> By the way --- Jekyll bootstrap uses `USERNAME.github.com` in its
> examples, yet GitHub Pages keeps talking about `USERNAME.github.io`
> (*com* vs. *io*). Apparently there was a
> [renaming operation](https://github.com/blog/1452-new-github-pages-domain-github-io)
> moving user and project pages from github.com to github.io in
> April 2013.  I tested that both schemes (e.g. `USERNAME.github.io`
> and `USERNAME.github.com` repository names) work, but accesses to
> the `USERNAME.github.com` URL will redirect you to `github.io`
> address.  Note that Jekyll bootstrap instructions are likely to be
> updated at some point in time, so this note about the inconsistency
> might be obsolete by the time you read this.

After you're done pushing, wait a while and navigate to
`http://USERNAME.github.io/`.
