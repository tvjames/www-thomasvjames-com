---
author: tvjames
comments: true
date: 2011-02-27 20:28:09+00:00
layout: post
slug: deployfu-com-its-like-heroku-for-net-mono-web-apps
title: DeployFu.com its like heroku for .net (mono) web apps
wordpress_id: 13
categories:
- Development
tags:
- asp.net
- coding
- deployfu
- moncai
- mono
archive: 
- 2011
2011:
- '02'
---

I've been looking forward to [moncai](http://www.moncai.com/) since its announcement back in November 2010. Its being developed by the guys at SineSignal and looks to be pretty promising.

Moncai sounds like heroku for .net built on mono, with DVCS to boot.

> Coming soon, the easiest way to deploy and scale your .NET/Mono web apps, by pushing to the cloud using Git or Mercurial. Once deployed, you can scale your app up and down based on load and pay for only what you use.

They've been pretty quiet since the announcement, as SineSignal also used it as a way to guage interest in the project. No doubt the interest would be pretty high as there aren't too many .net based cloud solutions. Given it was to be built on mono it was even more interesting.
Recently A colleague of mine put on [deployfu](http://www.deployfu.com/) which is a pretty similar setup to moncai, but its publicly available and free (for now).

DeployFu's premise is as simple as it can get, sign up and provide an ssh public key, create an application container and git push. DONE. Nothing more.

The git push is picked up by the deployfu infrastructure and your solution will be built, provisioned and deployed as part of the push.

The icing on the cake, deployfu also supports [Manos](https://github.com/jacksonh/manos), [Pylons](http://pylonshq.com/), [Rails](http://rubyonrails.org/) and [Node.JS](http://nodejs.org/)!

What more could you need?

