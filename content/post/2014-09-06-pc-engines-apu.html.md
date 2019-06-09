---
author: tvjames
comments: false
date: 2014-09-06 19:10:00+10:00
layout: post
slug: pc-engines-apu
title: PC Engines APU - Home router replacement
categories:
- Technology
tags:
- pcengines-apu
- linux
- router
archive: 
- 2014
2014:
- '09'
---

I've not been much of a fan of off-the-shelf home routers for a long while now. Always opting to build a linux box of some sort to do the job, going back this used to be the old white box with a couple of network cards, and until recently it was a [DreamPlug](https://www.globalscaletechnologies.com/t-dreamplugdetails.aspx) plug-pc. The DreamPlug was starting to have some power issues, so it was best to pro-actively replace it. 

A colleague suggested I take a look at the [PC Engines ALIX](http://www.pcengines.ch/alix.htm), and the (then) in development [APU](http://www.pcengines.ch/apu.htm). The ALIX sounded interesting, but given that the APU was right around the corner I decided it was best to wait and get the new model. I ordered the [Voyage Wireless Kit](http://store.voyage.hk/KMPD3bw.php?id=110) once the APU was available for sale, as this included everything I needed (enclosure, SSD, wifi, etc exlcuding PSU), also being shipped from Hong Kong I hoped it would arrive quickly, which it did thanks to SpeedPost. 

> As an aside, I choose to run a linux based router generally for two reasons. I like being able to script up, and control the configuration of the router without having to use the generally, very crappy web based UIs that most have; and secondly that I can then manage the router as I see fit and are not limited to the provided features of the device (such as multiple IPoverIP tunnels), which usually wont change once released. With linux I can upgrade as new releases occur. 

At the heart of the APU is a low power AMD x86/x64 cpu, unlike the DreamPlug which was ARM based. This means that all the regular linux distrobutions will be suitable without needing anythign to specifically target the device. I chose to use Debain. 

[![Internal view of the APU board](/content/posts/images/IMG_1938_zps756bb972.jpg)](/content/posts/images/IMG_1938_zps756bb972.jpg)

> Shown left to right, GSM Mini-PCIe, Wifi & 16GB SSD (mSata). There is also a SIM card slot on the underside of the SD card reader, wired up to one of mini-pcie slots. 

The voyage kit includes everything needed, except a suitable PSU, with some assembly required. For the PSU i found that an old Apple Airport Extreme PSU works perfectly. 

I purchased a USB serial adapter & a null-modem cable to make installing linux a bit easier, as I wasnt familiar with the device. This is nessesary as no form of display-out is provided on the device. I purchased the [Serial](http://www.decisivetactics.com/products) app for the mac to make the software side of the terminal emulation easier. 

## Linux Installation

The installation tripped me up and had me scratching my head for a bit trying to get the debian live CD to work with the APU. 

The live CD needs to be configured to output to the serial console, using the correct speed for the APU. However, to update the live CD configuration I found that using [unetbootin](http://unetbootin.sourceforge.net/) on windows (not Mac if you want to stay sane) was the easist way to get a writeable USB to update the config files. Alternative suggestions are very welcome. 

I found that updaing the following successfully allowed the console to be used for display output and a normal linux install to proceed. Once installed and networking setup, everything else was performed over SSH. 

The PC Engines forum was quite useful for getting this right, the post ['APU + Ubuntu 14.04 LTS - install via serial console'](http://www.pcengines.info/forums/?page=post&id=E25612E9-84F0-4DCF-A876-1E92FD1D065C&fid=1A77794F-FF7D-44CA-AF64-CAA2588102ED) in particular. 

**syslinux.cfg** include the following at the start of the file:
```text
# D-I config version 2.0
CONSOLE 0
SERIAL 0 115200 0
```

Update the kernel entry to include ```console=ttyS0,115200n8``` like so: 
```text
label unetbootindefault
menu label Default
kernel /isolinux/rescue64
append initrd=/isolinux/initram.igz rescue64 scandelay=1 console=ttyS0,115200n8 -- rescue32 scandelay=1
```

**isolinux/isolinux.cfg** include the following at the start of the file:
```text
# D-I config version 2.0
CONSOLE 0
SERIAL 0 115200 0
```

## Linux Setup

I needed to do a couple of things to complete the install on debian. Taking some cues from [Debian installer USB Stick for PC Engines APU board with mSATA drive](http://dev.hochwald.net/pcengines-apu-debian-iso)

### sysctl 

From [pcengines-apu-debian-iso / profiles / apu.postinst](http://dev.hochwald.net/pcengines-apu-debian-iso/src/acffaa8b6e595f4439746ca22a4a797429afe1ba/profiles/apu.postinst?at=master):

```bash
cat >/etc/sysctl.d/apu.conf <<EOF
vm.swappiness=1
vm.vfs_cache_pressure=50
EOF
```

### Ensure the serial console is used by grub

Edit ```/etc/default/grub```, update: 

```text
GRUB_CMDLINE_LINUX_DEFAULT="quiet console=ttyS0,115200n8"
```

Then run (per the instructions in the file):

```bash
update-grub
```

### Enable non-free package source for apt

Edit ```/etc/apt/sources.list``` ensuring that ```non-free``` is used. Then run ```apt-get update```.

### Install device firmware

Run the following for the ethernet & wifi firmware:

```bash
apt-get install firmware-realtek
apt-get install firmware-atheros
```

### Install sensors for temperature monitoring

```bash
apt-get install lm-sensors
sensors-detect
sensors
```

## Final Thoughts

The APU is a very capable little unit, which has been running stable for over a month in a low airflow area. I originally had some concerns about heat disapation but the unit remains about 52.0°C most of the time. 

I'm still yet to setup the GSM device as a backup network link, hopefully a future post. 

[This Gist includes output from a number of common linux utils that provide hardware information, if that's your thing.](https://gist.github.com/tvjames/082f244dbf3aff703c75)
