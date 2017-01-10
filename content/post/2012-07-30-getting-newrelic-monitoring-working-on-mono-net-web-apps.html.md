---
author: tvjames
comments: true
date: 2012-07-30 10:28:08+00:00
layout: post
slug: getting-newrelic-monitoring-working-on-mono-net-web-apps
title: Getting NewRelic monitoring working on Mono .Net Web Apps
wordpress_id: 253
---

About a week ago I set out attempting to get [NewRelic](https://newrelic.com)'s .Net Application instrumentation working on for web apps running on the Mono .Net runtime. I've been using NewRelic's Lite plan for monitoring a number of workpress blogs I host for friends and the various VPSes I have around the world. I've always wanted to extend this monitoring to the asp.net mcv apps I have running, but as I host them on Linux with Mono this was completely unsupported and a few google searched on the topic yielded little help. With access to a standard plan it was time see if it was possible.

`Please Note that running the NewRelic monitoring on Mono is completely unsupported by NewRelic and YMMV. If this breaks your system or a NewRelic upgrade prevents this from working then you'll be on your own.`

`Also, I am not affiliated with NewRelic in any way.`

If you haven't tried out the NewRelic application monitoring, give it a go, its free for a Lite plan which gives you pretty good metrics but only keeps the last 30 minutes of data. It allows you to monitor:

  * All the basics
  * Time taken in internal calls to external sites (this is pretty handy)
  * Process memory use
  * Real load time in the browser through JS injection
  * Database calls including SQL statements

## TL;DR

  * Grab the installer for either x86/x64
  * Using msiexec on a windows box extract the contents using an administrator install (msiexec /a )
  * Copy the GAC dlls into your application's bin
  * Copy the newrelic.xml to newrelic.config in your application
  * Add a httpModule reference to `"NewRelic.Agent.Core.Tracer.Web.NewRelicHttpModule, NewRelic.Agent.Core"` in your web.config file.
  * Edit the newrelic.config file and supply your license key
  * Deploy & watch those stats roll in
  * Missing:
    * Externals tracking
    * Database tracking
    * Most other tracking

## The guts of it

The [NewRelic documentation](https://newrelic.com/docs/dotnet/new-relic-for-net) was the first port of call on working out if this little endeavour was even possible and I must say they provide a decent amount of information about how the .net monitoring agent works. It's pretty clever if you ask me.

The documentation explains the .net agent uses the built-in CLR profiling hooks to kick off the instrumentation, and a quick look at the environment variables after installation show that the `NewRelic.Agent.IL.dll` contains the profiler bootstrap.

Reading up on how to build a CLR profiler didn't provide any great insight into the problem of how the agent was started and hooked into the IIS/Asp.net runtime.

I started with analysing the installer, I grabbed the 64bit one but the 32bit one should work as well. I found that along with the profiler DLL there were 4 others that get installed into the GAC.

  * NewRelic.Agent.Core.dll
  * NewRelic.ICSharpCode.SharpZipLib.dll
  * NewRelic.Json.dll
  * NewRelic.Log.dll

Using reflection over the `NewRelic.Agent.Core` DLL (as the others were obviously supporting modules) revealed a number of interesting classes and interfaces. These ones peeked my interest:

  * IAgent
  * Agent

The Agent class contained a single public constructor as far as I could tell. This was worth a shot, I copied the newrelic.xml file into newrelic.config along side my app's web.config and supplied my newrelic license key and using mono develop started the app on my local machine.

I waited five minutes and checked my newrelic dashboard. To my surprise my application showed up along with the hostname of my laptop listed under instances. Surely it couldn't be this easy?

I then spent the next few minutes generating as many request as I could, unfortunately none of them were showing up on my dashboard.

At this point I thought to myself, that i must be missing something obvious so i reached out to the newrelic team on twitter just to see if they could point me in the right direction. Their support was excellent and although they advised me that mono was not supported a number of time, asked me to raise a ticket, which i did.

While providing some information for the support ticket, I was thinking about how I would implement the request tracking. I did miss the obvious, `IHttpModule`.

A few minutes later and quick reflection check and low and behold there was a single class implementing `IHttpModule` in the Core DLL. I was hoping that this was it, I wired it up into the web.config and restarted the local debug session of the app. Hitting it with quite a few initial requests and waiting a minute to be sure that the data was on its way to the dashboard.

I checked the dashboard, and **IT WORKED**.

Unfortunately, a quick check revealed that the other metrics indulging external calls and database monitoring weren't working, and I suspect will take considerable more effort to figure out.

Thanks NewRelic for the awesome monitoring platform and for not making it too hard to unofficially get it running on mono.

For those that are interested, the LINQPad code for reflecting over the DLL to find the `IHttpModule`:

```
var type = typeof(IHttpModule);
var types = typeof(NewRelic.Agent.Core.Agent).Assembly.GetTypes()
    .Where(p => type.IsAssignableFrom(p));

types.Dump();
```

