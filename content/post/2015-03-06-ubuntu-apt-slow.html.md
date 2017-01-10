---
author: tvjames
comments: true
date: 2015-03-06 08:50:00+10:00
layout: post
slug: ubuntu-apt-slow-on-ec2
title: Making Ubuntu apt faster on ec2
categories:
- Technology
tags:
- ubuntu
- ec2
---

_Note, this is based on experience in ap-southeast-2 only, using Ubuntu Cloud AMIs_

I've found the performance of the default Ubuntu AWS region based apt mirror to vary greatly. Sometimes downloading a package will occur at 6+MB/s while other times it'll be barely 1KB/s. 

<div>
<blockquote class="twitter-tweet" lang="en"><p>157 BYTES PER SECOND on AWS. What the actual fuck! <a href="http://t.co/u0VJT7sJI1">pic.twitter.com/u0VJT7sJI1</a></p>&mdash; Thomas James (@thomasvjames) <a href="https://twitter.com/thomasvjames/status/571177418276253698">February 27, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
</div>

This can be a problem if you're not pre-baking you're AMIs and you hit the grace period for instance spin-up in an autoscale group with a health check. If you're not careful you'll have a cycle of spin-up->unhealthy->terminate, which could end up being quite costly. 

The source of this would _appear_ to be load on the mirrors. Thankfully canonical have provided a simple solution. [Switch over to the S3 backed apt mirror for that region](http://cloud.ubuntu.com/2012/01/regional-s3-backed-ec2-mirrors-available-for-testing/). Why these aren't the default, who knows. 

Step 1: Throw this in your instance's USER_DATA: 

```
EC2_REGION="ap-southeast-2"
sed -i -e "s/${EC2_REGION}.ec2.archive.ubuntu.com/${EC2_REGION}.ec2.archive.ubuntu.com.s3.amazonaws.com/g" /etc/apt/sources.list
apt-get update
```

Step 2: Enjoy much faster apt-get. 

Step 3: There is no _step 3_. 
