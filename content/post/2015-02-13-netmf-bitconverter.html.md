---
author: tvjames
comments: true
date: 2015-02-13 10:17:00+10:00
layout: post
slug: netmf-bitconverter
title: .net MicroFramework 4.3 BitConverter
categories:
- Technology
tags:
- netmf
- netduino
archive: 
- 2015
2015:
- '02'
---

The ```BitConverter``` was added to the .net microframework in version 4.3 and provides a way to turn an array of bytes into a meaningful primitive such as a ```long```. 

```
var bytes = new byte[] 
{
    0x01, 0x02,
    0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A,
}
var someValue = BitConverter.ToInt64(bytes, 2);
```

Using it in my netduino targeting code, I encountered a number of occurrences where the netduino would hard lock and require a reset to become responsive again. I traced this back to some usages of the ```BitConverter``` but not others. Essentially the ```var someValue = ...``` line in the above code snippet. 

In researching this issue I stumbled upon a related bug report in the netmf project, [BitConverter startIndex not correct](https://netmf.codeplex.com/workitem/2288), which suggested that with the way the code was implemented the values being converted needed to be word aligned otherwise it wouldn't work. 

> It looks like there are alignment issues. 32 bit pointers must be aligned on arm processors. Adding packed would solve this or use memory copy.
> 
> I was able to reproduce the issue on the EMX, G400, and Hydra. The Cerb and G120 perform properly, however they crash on non-zero start indexes for the 64bit conversions. I looked at the native code and it seems fine, it just adds the index to the pointer and casts it. It’s essentially: reinterpret_cast<int>(buffer + start_index). 

Giving this a try by padding the ```long``` value out was successful, ending the hard lock & reset cycle. 

Eg
```
var bytes = new byte[] 
{
    0x01, 0x02, 0x00, 0x00, 
    0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A,
}
var someValue = BitConverter.ToInt64(bytes, 4);
```


