---
author: tvjames
comments: true
date: 2012-02-23 11:22:27+00:00
layout: post
slug: relax-unwind-with-a-little-redis
title: Relax & Unwind with a little Redis
wordpress_id: 222
---

In a previous post, [Unwind: Sequences in the cloud](http://www.thomasvjames.com/2011/10/unwind-sequences-in-the-cloud/), I wrote about one of the challenges of moving from the relational database world to the non-relational database world. The issue of generating numerical sequences. 

This is an important issue for a number of reasons: 
	1) Numerical sequences are the de-facto standard for identity column generation.
	2) Numerical sequences are easy to display to the end user
	3) Easy for the end user to remember and recant
	
The GUID/UUID data type is great for replacing the numerical ID of a record with something that can stand up to the challenges of distributed data, but they are not very suitable for use by the end-user. In some applications you really do still want to be able to generate a reliable numerical sequence number, such as for an invoice number. 
	
So how to we do this? 
	
Introducing [Redis](http://redis.io/), another NoSQL brethren of the Key-Value store type but with a whole lot more. It's stable, fast and supports a number of data type operations on the server-side. 

The operation we care about is one of the simplest: 
	[String INCR](http://redis.io/commands/incr)

We'll use Redis with this operation to keep track of our applications counters. This way we have the distributed power of CouchDB combined with the stability and speed of Redis. 

It may seem like overkill to add an additional component to our software stack _just_ to handle the task of keeping a counter, but Redis fits the mould perfectly in this case. Its also simple to setup and use, not adding much to the solution's overhead. Especially considering that, like CouchDB, the redis instance is "in the cloud".

Within the sample Unwind application, the implementation is as simple as implementing the counter interface with the ServiceStack Redis client. 


    
    <code>
    using (var redis = new RedisClient("Host", 1234)){
    	redis.Password = "Password";
    	
    	var counter = redis.IncrementValue("UnwindNextLinkCounter");
    }
    </code>



Can it get any harder?
