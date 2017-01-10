---
author: tvjames
comments: true
date: 2015-11-28 16:20:15+10:00
layout: post
slug: battle-of-the-4g-dongles
title: Battle of the 4G dongles
categories:
- Technology
tags:
- 4g
- wifi
---

Having recently received my kickstarted GLocalMe G2 Global Roaming device & with a few past devices just sitting around I thought I'd put them to the test. In a completely non-scientific way.

* Telstra post-paid data share sim
* Dongles
    - ZTE MF91 (Telstra Branded)
    - Netgear AirCard 760S (Telstra Branded)
    - GLocalMe G2 (Software Version 151122)
* Devices
    - iPhone 6 Plus
    - Google Nexus 6 
    - MacBook Pro Retina 13" 2015 model

Each device will use the native speedtest for that platform, the dongles will be running on USB power during the test. The speedtest results for the iPhone running direct & as a hotspot on the Telstra network will be included for reference. The devices were placed on the same desk, beside each other. Speedtest Beta was used in Chrome on the MacBook. 

## ZTE MF91

```
LTE: 1800, 2600 MHz with up to 40Mbps data
UMTS: 850, 900, 2100 MHz with up to 21Mbps data
WiFi: 802.11 b/g/n
```

This has been my "go to" device for a few years now. It's been exceptionally reliable (even if the admin portal is terrible) with excellent battery life for a full day of sporadic usage. It's also the lightest of the 3 dongles. 

| Test Device   | Ping  | Download   | Upload     |
| ------------- | ----- | ---------- | ---------- |
| MacBook (CLI) | 71 ms | 6.4 Mbps   | 8.4 Mbps   |
| MacBook (Web) | 25 ms | 24.01 Mbps | 26.51 Mbps |
| iPhone 6+     | 36 ms | 14.80 Mbps | 30.85 Mbps |
| Nexus 6       | 28 ms | 28.32 Mbps | 36.01 Mbps |

## Netgear AirCard 760S

```
LTE: 1800/2100/2600 MHz up to 100 Mbps download, 
     up to 50 Mbps upload (LTE Catagory 3)
UMTS: Dual-Carrier HSPA+ 850/900/2100 MHz 
WiFi: 802.11 b/g/n
```

| Test Device   | Ping  | Download   | Upload     |
| ------------- | ----- | ---------- | ---------- |
| MacBook (CLI) | 61 ms |  2.60 Mbps |  7.30 Mbps | 
| MacBook (Web) | 31 ms |  3.56 Mbps |  6.19 Mbps | 
| iPhone 6+     | 27 ms |  6.82 Mbps | 17.10 Mbps | 
| Nexus 6       | 26 ms | 28.60 Mbps | 32.06 Mbps | 

## GLocalMe G2

```
UMTS Band 1/2/4/5/8 
LTE-FDD Band 1/3/5/7/8/17/20 
LTE-TDD Band 39/40/41 
GSM 850/900/1800/1900MHz
WiFi: 802.11 b/g/n
```

This is quite an interesting device, it includes a built in sim card (a "cloud sim") which is used for the GLocalMe global roaming service and two additional micro-sim slots. The 6000 mAH battery is a nice plus. 

| Test Device   | Ping  | Download   | Upload     |
| ------------- | ----- | ---------- | ---------- |
| MacBook (CLI) | 58 ms | 13.00 Mbps | 10.00 Mbps | 
| MacBook (Web) | 28 ms | 28.59 Mbps | 31.33 Mbps | 
| iPhone 6+     | 34 ms | 24.77 Mbps | 34.08 Mbps | 
| Nexus 6       | 18 ms | 38.07 Mbps | 37.14 Mbps | 

## iPhone 6 Plus 

| Test Device   | Ping  | Download   | Upload     |
| ------------- | ----- | ---------- | ---------- |
| MacBook (CLI) | 66 ms | 16.00 Mbps | 12.00 Mbps | 
| MacBook (Web) | 27 ms | 27.28 Mbps | 24.58 Mbps | 
| iPhone 6+     | 28 ms | 91.01 Mbps | 37.91 Mbps | 
| Nexus 6       | 28 ms | 24.48 Mbps | 34.99 Mbps | 

## ADSL 2+ 

For _woeful_ comparison. 

| Test Device   | Ping  | Download   | Upload     |
| ------------- | ----- | ---------- | ---------- |
| MacBook (CLI) | 45 ms | 11.00 Mbps |  1.20 Mbps | 
| MacBook (Web) | 21 ms | 12.10 Mbps |  1.26 Mbps | 
| iPhone 6+     | 23 ms | 13.32 Mbps |  1.43 Mbps | 
| Nexus 6       | 22 ms | 13.39 Mbps |  1.35 Mbps | 

Interpret how you like. 


