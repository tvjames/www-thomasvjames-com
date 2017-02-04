---
author: tvjames
comments: true
date: 2012-06-17 06:35:05+00:00
layout: post
slug: getting-to-know-fabric-remote-server-control
title: 'Getting to know Fabric: Remote server control'
wordpress_id: 228
archive: 
- 2012
2012:
- '06'
---

I use a number of cheap VPS instances to test out various platforms and tools. Sadly, as is the nature of the low end VPS market, not all of them are reliable which has led me to re-installing & customising quite a number of times.

My first approach to this was to write a pseudo-script, a document that had blocks of command line that could be copy-and-pasted into the ssh window of a VPS I was setting up. This worked for a while, but was prone to errors. So I started looking for automation alternatives.

I considered chef & puppet but the learning curve just to get something up and running was considerable, and all i had was the evenings and weekends. I can't recall how, but i stumbled upon [Fabric](http://fabfile.org/) which is a python tool that wraps an ssh connection, allowing you to define "fabfiles" which contain the remote (and local) commands to be executed. It's a lot more than that, but at the heart of it it's a python environment for running commands over ssh, including scp and rsync.

This sounded fantastic, just what I needed. The fabfiles need to be written in python so i set out to learn enough python to be terrible at it.

### Getting it up and running.

Installation of fabric on OS X couldnt be easier, just drop into the terminal and run the following:

```
sudo easy_install fabric
```

Which will make use of python's package manager to grab the latest copy of fabric, as well as anything it needs and install it for you.

### Testing it out

Once you've got fabric installed, fire up your favorite text editor and create a fabfile.py in which you can define your tasks. I choose to use the task annotation so mine look something like:

```
@task
def nsreload():
    sudo("rndc reload")
```

Which i can execute like so:

```
fab --hosts=localhost nsreload
```

If, like me, you've configured private-key based authentication for ssh this is a password-less, repeatable and easy way to run defined commands on a remote host. You might need to enter your password for sudo.

### Bootstrapping a VPS

Taking this a bit further it allows me to, given a fresh install of debian 6 minimal run a single command which will bootstrap the VPS to my desired initial (safe) configuration ready to be used.

```
fab hostname bootstrap
```

Which does all of the following:

  * Updates the apt sources
  * Upgrades existing packages
  * Installs sudo
  * Configures sudo
  * Changes the root password
  * Sets up a personal user account
  * Pushes my ssh public key
  * Verifies the account is configured correctly
  * Reconfigures sshd to disallow password and root logins
  * Configures the timezone (to UTC)
  * ... and many many more

At the moment it still requires a small amount of interactivity, mostly around the setting of passwords as I, obviously, dont want those stored in the script files.

I've also configured a number of recipies for common "roles" that may need to be setup, include:

  * DNS Master
  * DNS Slave
  * DNS Master refresh
  * Backup to s3
  * Backup to rsync

Finally, like any good developer, all of my fabfiles, templates and host configuration are version controlled, using Hg. I'm really enjoying using fabric as it's made it very easy to deploy/re-deploy a service to a new host or just record a series of steps to setup something new that can later be refined into a recipe for a "production" deployment.

Infrastructure as code. Love it!

