---
author: tvjames
comments: false
date: 2010-05-09 13:41:01+00:00
layout: post
slug: failed-attempt-to-read-the-ssd
title: Failed attempt to read the SSD
wordpress_id: 28
categories:
- JooJoo
tags:
- joojoo
---

Some time ago I ordered the [SSDMA](http://www.hwtools.net/Adapter/SSDMA.html) which is a mini PCIe (SATA/PATA) to USB adapter, This item arrived about two weeks ago but because of an out-of-state trip I havent been able to write up my results yet.

In a nutshell: Failed!

The SSDMA was unable to either read the SSD or the USB controller in the SSDMA was damaged. Either way I was unable to get the combination to work on any of my computers (MacBook Pro, Work DELL). I was rather disappointed given the SSD sports the JMF601 Flash controller which I am lead to believe is a pretty common controller.

Not to worry, my reading on the JMF601 indicated it sported an internal USB controller and from the looks of the SSD there were pinouts for a USB header. I butchered an old USB cable, looked up the wiring guide and went to work on it.

With no wiring diagram on the SSD board to indicate the pins I just "guessed" at the ground and went from there. Unfortunately both wiring combinations I tried did not result in a being able to access the SSD. Thankfully it also didnt result in frying the SSD either.

So after a few nights effort trying different combinations I've given up on the direct access to the SSD.

My next option is to look at buying a dirt cheap netbook that supports the JMF601 chipped SSD and trying to use that with USB boot to peek into the filesystem, but which one?
