---
author: tvjames
comments: true
date: 2011-10-30 08:25:53+00:00
layout: post
slug: unwind-sequences-in-the-cloud
title: 'Unwind: Sequences in the cloud'
wordpress_id: 200
categories:
- Development
tags:
- coding
---

When starting to build the url shortener, the first thing i did was research how others had solved the problem before me. This research turned up a lot of the same thing, a simple database where the autonumber/identity column auto generated value was then used as the link id and turned into something non-numeric like [base62](http://birdhouse.org/blog/2010/10/24/base62-urls-django/) for display to the user.

This approach is all well-and-good for a single relational database, but trying to replicate this with CouchDB just felt **wrong**. This problem needed a _webscale_ solution, one that would scale and not be at risk of conflict. I needed an eventually consistent solution to the problem and auto-numbers weren't it.

Now, yes for this little prototype piece of software i didn't technically **need** a web scale solution, but i **needed** to build one to learn how to do it and more importantly to fail at it.

The best idea i could come up with at the time was assigning a unique id to each web node in the group and generating a byte array that was then hashed and cut down to a smaller value before being encoded as base62. This worked pretty well, it was easy to check for the existence of a document and the likelihood of a collision was pretty minimal.

    <code>value = base62(node-id(1 byte) + hash(url)(4 bytes) + random-bytes(1 byte))
    </code>

** This solution just didn't _feel_ right **

So i started to investigate how to replicate the sequence number solution in a way that wouldn't clash with the web-scale approach, in that it needed to be able to work for a n-node scenario, but would still provide a sequential, **unique** number.

The research took me to a pretty obvious place, implement the sequence number provider as a service that each node can request a sequence number from, this way the problem of generating a unique sequence of sequential numbers can be solved without needing to worry about the rest of the solution.

Within a single application the implementation of the solution becomes pretty simple

    <code>public class Counter
    {
        private long _counter = 0;

        public Counter(long seed)
        {
            this._counter = seed;
        }

        public long NextValue()
        {
            return Interlocked.Increment(ref this._counter);
        }
    }
    </code>

The next problem is then persisting the value of the counter. Depending on the solution this could either be performed with some sort of journalling system that proxies the counter, or simply persisting the value to a text file that is read on startup.

