---
author: tvjames
comments: false
date: 2014-05-21 11:58:52+00:00
layout: post
slug: game-of-life-as-an-i386-kernel
title: Game of Life as an i386 kernel
wordpress_id: 359
categories:
- Development
- Linux &amp; Open Source
tags:
- kernel
---

I wrote this; [Game of life implemented as an i386 kernel](https://github.com/tvjames/kernel-mode-game-of-life).





After reading through the excellent [Kernel 101 – Let’s write a Kernel](http://arjunsreedharan.org/post/82710718100/kernel-101-lets-write-a-kernel) post by [Arjun Sreedharan](http://arjunsreedharan.org/), I was motivated. I thought it would be interesting to see how difficult it would be to implement [Conway's Game of Life](http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) simulation as an extension to what I'd already done as part of the tutorial.





I set myself some goals; that it needed to be interactive & visual.





The kernel implements screen writing, cursor position updating and polling IO for the keyboard.





The screen is updated using the mapped memory method outlined in the tutorial, while the cursor position and the keyboard use C inline asm to read/write to the necessary ports.





I didn't go to the extent of implementing an IRQ based keyboard driver as I just wanted do the minimal to get a working interactive simulation. The simulation also uses a fixed size array thats allocated as part of the program rather than attempting to allocate and manage memory. This certainly limited the data structures available to use and forced me to really think about the most basic algorithm to get the job done.





It's not pretty, efficient or bug free, but it was a fun (re)learning exercise for a weekend. Taking me back to my uni days learning assembler, although much of what I learnt back then I had clearly forgotten.





Some thoughts on where it could go next:







  * interrupt driven keyboard driver


  * scancode to key events & translation into ASCII 


  * memory management 


  * user driven initial game state (eg using the arrow keys to _mark_ squares as initially _live_ then triggering the simulation run)





Doing the kernel development on a mac also posed some additional challenges in being able to successfully compile and link the kernel, as it was proving imposible to get the GNU linker on the mac. I found that setting up a [Vagarantfile](http://www.vagrantup.com/) and running ubuntu in a virtual machine to perform the build was the easiest way to get around the limitations I ran into.
