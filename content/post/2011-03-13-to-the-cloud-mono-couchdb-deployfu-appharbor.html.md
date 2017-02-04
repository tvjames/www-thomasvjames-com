---
author: tvjames
comments: true
date: 2011-03-13 19:31:44+00:00
layout: post
slug: to-the-cloud-mono-couchdb-deployfu-appharbor
title: To the cloud ... Mono, CouchDB, DeployFu & AppHarbor
wordpress_id: 11
categories:
- Technology
tags:
- appharbor
- asp.net
- coding
- deployfu
- mono
archive: 
- 2011
2011:
- '03'
---

A while ago i wrote a small asp.net mvc2 web app to try out [CouchDB](http://couchdb.apache.org/) as database platform. CouchDB is a little different from the regular database offerings in that it is known as a document database, widely known under the [NoSQL](http://nosql-database.org/) movement.

CouchDB provides a RESTful interface for storing documents. Documents are JSON strings and operations on documents are atomic in nature. CouchDB also includes powerful Map/Reduce functionality in the form of views, replication and even a built in application server.

So i set out to write a simple application to take advantage of the document store and map-reduce views. I wrote a URL shortener, because the world needs one more URL shortener and in keeping with the spirit of CouchDB it was called [Unwind](http://srvd.in/). Rather than hosting the CouchDB instance myself, i've been using the cloud hosting provided by [CouchOne](http://www.couchone.com/) as its just easier.

I started out by hosting the application myself (on linux with mono-2.8), but only having the database in the cloud just wasn't enough cloud for me, as in my previous post i was already aware of [Moncai](http://moncai.com/), but given it wasn't available i was made aware of [DeployFu](http://www.deployfu.com/) and then [AppHarbor](http://appharbor.com/). Both services have a free tier that i was eager to try out, but unfortunately they both only supported git at the time and i was using hg for version control.

My initial playing around involved a lot of stupid mistakes that koush (of deployfu) graciously helped me out with, usually involving me either committing too much or too little of my hg repo to git and pushing that to deployfu and then my repo structure wasn't quite right either, but after getting that sorted i had unwind running "in the cloud" on deployfu.

Not wanting to repeat the fun of keeping a git and hg repo in sync i started looking to git/hg bridges and found one, [hg-git](http://hg-git.github.com/) which was quite easy to setup on the mac after reinstalling Hg using python's easy_install and then following the hg-git install instructions. Once that it was a simple matter of setting up the git repos to push to and pushing. DeployFu picks up the push, compiles and deploys to AWS EC2.

I did run into a few problems repeating the process with appharbor using hg-git to push to the repo, but thankfully hg-git allows you to export the hg change-sets in git format which allowed me to use the normal git tools, less than idea but still pretty painless. AppHarbor however does run your solutions tests (multiple frameworks supported) and have a few other interesting features at the moment including configuration variables, cname support and collaboration.

> [Unwind](http://srvd.in/) privately hosted vps running debian linux and custom built mono-2.8 with patches

> [Unwind on DeployFu](http://unwind.deployfu.com/)

> [Unwind on AppHarbor](http://unwind.apphb.com/)

Finally keeping the spirit of the cloud the source is hosted on [BitBucket](https://bitbucket.org/).

