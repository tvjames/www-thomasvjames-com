---
author: tvjames
comments: true
date: 2013-09-15 00:08:40+00:00
layout: post
slug: vagrant-aws-rsync-on-windows
title: 'Vagrant AWS & rsync on windows '
wordpress_id: 291
categories:
- Development
tags:
- aws
- vagrant
---

I've been using [vagrant](http://www.vagrantup.com/) & [vagrant-aws](https://github.com/mitchellh/vagrant-aws) quite a bit lately, it's great to be able to fire up a VM to test something out then fire it up on an EC2 instance to try it out in the cloud. Easy as hell when running on linux/osx but less than obvious when doing it on Windows. Everything vagrant-aws works out of the box, except rsync.

There are two issues:
 * Not all the AMIs have rsync installed by default
 * Windows doesn't have rsync

The first issue can be overcome by adding a small `user_data` script that installs rsync on startup while the answer to the second is less obvious. There are a couple of rsync options available for windows.

I found the [cwRsync Free Edition](https://www.itefix.no/i2/content/cwrsync-free-edition) to work quite well.

Grab the installer (not the server installer), install and then add it to your path. After that as long as you're using an AMI with rsync available you should be good to go.
