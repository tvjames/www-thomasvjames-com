---
title: "Game of life implemented as an i386 kernel"
layout: post
nav: "test post"
---

<p>I wrote this; <a href="https://github.com/tvjames/kernel-mode-game-of-life" title="Game of life implemented as an i386 kernel">Game of life implemented as an i386 kernel</a>.</p>
<p>After reading through the excellent <a href="http://arjunsreedharan.org/post/82710718100/kernel-101-lets-write-a-kernel">Kernel 101 – Let’s write a Kernel</a> post by <a href="http://arjunsreedharan.org/">Arjun Sreedharan</a>, I was motivated. I thought it would be interesting to see how difficult it would be to implement <a href="http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life" title="Conway's Game Of Life">Conway’s Game of Life</a> simulation as an extension to what I’d already done as part of the tutorial.</p>
<p>I set myself some goals; that it needed to be interactive &amp; visual.</p>
<p>The kernel implements screen writing, cursor position updating and polling IO for the keyboard.</p>
<p>The screen is updated using the mapped memory method outlined in the tutorial, while the cursor position and the keyboard use C inline asm to read/write to the necessary ports.</p>
<p>I didn’t go to the extent of implementing an IRQ based keyboard driver as I just wanted do the minimal to get a working interactive simulation. The simulation also uses a fixed size array thats allocated as part of the program rather than attempting to allocate and manage memory. This certainly limited the data structures available to use and forced me to really think about the most basic algorithm to get the job done.</p>
<p>It’s not pretty, efficient or bug free, but it was a fun (re)learning exercise for a weekend. Taking me back to my uni days learning assembler, although much of what I learnt back then I had clearly forgotten.</p>
<p>Some thoughts on where it could go next:</p>
<ul>
  <li>interrupt driven keyboard driver</li>
  <li>scancode to key events &amp; translation into ASCII </li>
  <li>memory management </li>
  <li>user driven initial game state (eg using the arrow keys to <em>mark</em> squares as initially <em>live</em> then triggering the simulation run)</li>
</ul>
<p>Doing the kernel development on a mac also posed some additional challenges in being able to successfully compile and link the kernel, as it was proving imposible to get the GNU linker on the mac. I found that setting up a <a href="http://www.vagrantup.com/">Vagarantfile</a> and running ubuntu in a virtual machine to perform the build was the easiest way to get around the limitations I ran into.</p>
