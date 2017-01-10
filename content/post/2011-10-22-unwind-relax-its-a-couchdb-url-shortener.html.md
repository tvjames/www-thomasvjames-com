---
author: tvjames
comments: true
date: 2011-10-22 04:37:03+00:00
layout: post
slug: unwind-relax-its-a-couchdb-url-shortener
title: 'Unwind: Relax its a CouchDB URL Shortener'
wordpress_id: 194
categories:
- Development
tags:
- appharbor
- coding
- deployfu
- mono
---

Its been some time since I built [unwind](http://srvd.in/) as a project to learn about interacting with [CouchDB](http://couchdb.apache.org/) from .net as well as getting some experience in running .net on mono. It was an excellent sample application as well for testing out [DeployFU](http://www.deployfu.com/) & [App Harbour](https://appharbor.com/) which it still remains today.

## So, what is it?

Unwind is a simple URL shortener in in the "cloud". The backend storage is CouchDB provided by CouchBase and the front end is Asp.net MVC2.

It provides a simple interface for creating & tracking shortened links.

## How does it work?

The front end in this case isn't too interesting so I'll focus on the CouchDB documents and their mapping into .net land.

We have three main entities we need to be concerned about, the original target link, the shortened link and the tracking record. I considered a number of document structures for these objects including the following:

```
links/foobar = {
    shortCode: "foobar",
    url: "http://www.example.com/",
    logs: [
        {ip: .., browser: ..., timestamp: ..}
    ]
}
```

This model looked pretty simple, all the concerns about the domain are kept in one place but this model has the drawback that every time someone uses the short link the document must be read, updated and written and in a web environment this could quickly lead to document conflicts.

So i looked at a model that separated the log records from the main document.

```
links/foobar = {
    shortCode: "foobar",
    url: "http://www.example.com/"
}

links/foobar-timestamp = {
    shortCode: "foobar",
    ip: .., browser: ..., timestamp: ..}
}
```

This was the model i settled on, each request would only require a document lookup and a single document write. Both document structures would still allow the same style of CouchDB map-reduce views to be created, but the second would mean there would be less updates to the view for each time a shortened link was accessed.

Coming up in Part 2 I'll detail some of the choices for generating the short code and the source will eventually be available.

