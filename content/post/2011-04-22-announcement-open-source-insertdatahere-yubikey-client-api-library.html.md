---
author: tvjames
comments: true
date: 2011-04-22 03:37:58+00:00
layout: post
slug: announcement-open-source-insertdatahere-yubikey-client-api-library
title: 'Announcement - Open Source: InsertDataHere.Yubikey Client API library'
wordpress_id: 106
categories:
- Development
tags:
- coding
- insertdatahere
- mono
- open source
- yubikey
---

I've been interested in the [Yubikey](http://www.yubico.com/yubikey) for some time now, it's an interesting approach to the problem of two-factor authentication with a physical token that is a space normally owned by the big guys.

Yubikeys are a physical usb device that emulates a HID keyboard profile and when you need to supply the second factor authentication response you just hit the button on the usb key.

The guys behind the Yubikey, Yubico, provide the devices pre-configured for their cloud validation api which is accessible via a number of endpoints using a REST style api. Its all very well documented and most of the implementations in various languages are open source.

Today there is another: **[InsertDataHere.Yubikey](https://bitbucket.org/tvjames/yubikey/wiki/Home)**

This is a .net based client api interface written in c# and supports mono (was developed on as well).

Its alpha quality but fully featured supporting parallel queries, https, hmac message verification & ssl certificate fingerprint checking.

So if you need a two-factor authentication solution, I'd suggest checking out Yubico's Yubikey and giving it a go.

