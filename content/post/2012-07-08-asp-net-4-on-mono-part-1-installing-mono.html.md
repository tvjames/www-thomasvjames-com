---
author: tvjames
comments: true
date: 2012-07-08 10:02:12+00:00
layout: post
slug: asp-net-4-on-mono-part-1-installing-mono
title: ASP.net 4 on Mono - Part 1 - Installing Mono
wordpress_id: 244
archive: 
- 2012
2012:
- '07'
---

Today I found myself attempting to automate the process of getting the latest mono build running on debian and serving up a web app with some degree of fault resistance.

The goals:

  1. Mono is downloaded and built by script
  2. Mono is installed into a non-standard folder in /opt for easy update
  3. As little custom config as possible
  4. Should be fault resistant against a host process failure

A lot of this has already been done and I'm just building on the work here [Hosting Nancy on Debian with Nginx](http://humblecoder.co.uk/nancy/hosting-nancy-on-debian-with-nginx).

What we're going to be doing in parts is:

  1. Installing mono & xsp. We'll use XSP as it hosts asp.net web apps out of the box
  2. Setup supervisord so that it will keep our XSP processes alive
  3. Use nginx to serve static content and proxy requests through to our new load balanced cluster of XSP processes

Note, I'm opting to download and build mono as opposed to using the debian package manager as this allows me not only to build the latest, but completely control the build process and as I'm installing it into /opt there isn't a need to keep track of it in a package registry.

I'll be using [fabric](http://fabfile.org/) to automate the process from my laptop.

## Setting Up

To get started you'll need an additional fabric file with command commands. Grab the following and put it into a file called "system.py".

**system.py:**

```
from fabric.api import *

def run_or_sudo(command):
    if (env.user == 'root'):
        run(command)
    else:
        sudo(command)

@task
def install(name, source=None):
    if (source is None):
        run_or_sudo('apt-get install %s' % name)
    else:
        run_or_sudo('apt-get -t %s install %s' % (source, name))
```

**fabfile.py:**

```
@task
def build_and_deploy_mono(version='', prefix=''):
    if (version == ''):
        version = '2.10.9'
    if (prefix == ''):
        prefix='/opt/mono-{version}'.format(version=version)
    system.install('build-essential bison gettext pkg-config')
    run('wget http://download.mono-project.com/sources/mono/mono-{version}.tar.bz2'.format(version=version))
    run('tar xjvf mono-{version}.tar.bz2'.format(version=version))
    with cd('mono-{version}/'.format(version=version)):
        run('./configure --with-xen_opt=yes --prefix={prefix}'.format(prefix=prefix))
        run('make')
        system.run_or_sudo('make install')
    print(yellow('mono {version} installed into {prefix}'.format(version=version,prefix=prefix)))
    return prefix
```

Its pretty self-explanatory, but the task _build_and_deploy_mono_ does the following:
* Sets the version & installation prefix
* Downloads & untars the source package
* Configures and build the package
* As superuser (via sudo) installs the build package into the prefix

## Installing Mono & XSP

You can run the above from the command line on your local machine as, using the defaults:

```
$ fab --host=remote-host build_and_deploy_mono
```

Next we're going to need to download, build and install XSP, to do this append the following to your "fabfile.py".

**fabfile.py:**

```
@task
def build_and_deploy_mono_xsp(prefix, version=''):
    if (version == ''):
        version = '2.10.2'
    #if (prefix == ''):
    #   prefix='{mono}-xsp-{version}'.format(mono=mono_prefix,version=version)
    run('wget http://download.mono-project.com/sources/xsp/xsp-{version}.tar.bz2'.format(version=version))
    run('tar xjvf xsp-{version}.tar.bz2'.format(version=version))
    with cd('xsp-{version}'.format(version=version)):
        run('PATH={prefix}/bin:$PATH PKG_CONFIG_PATH={prefix}/lib/pkgconfig/:$PKG_CONFIG_PATH ./configure --prefix={prefix}'.format(prefix=prefix))
        run('make')
        system.run_or_sudo('make install')
    print(yellow('mono-xsp {version} installed into {prefix}'.format(version=version,prefix=prefix)))
    return prefix
```

And at the command line we can install it like so:

```
$ fab --host=remote-host build_and_deploy_mono_xsp:mono_prefix=/opt/mono-2.10.9
```

The command is similar to the mono install, but this time we're passing in an argument that allows the XSP task to know where mono was installed.

Once the task is run, we have:

  * Mono setup in: /opt/mono-2.10.9
  * XSP setup in: /opt/mono-2.10.9

I was originally going to setup XSP in its own prefix, but this proved troublesome with the GAC, assembly loading & shared library loading so for now it's easier to just use the same common prefix.

You can test that both mono and xsp are installed and operational with the following commands, run from the console of the remote server:

```
$ /opt/mono-2.10.9/bin/mono --version
$ PATH=/opt/mono-2.10.9/bin:$PATH /opt/mono-2.10.9/bin/xsp4
```

You should see output similar to:

```
$ /opt/mono-2.10.9/bin/mono --version
Mono JIT compiler version 2.10.9 (tarball Sun Jul  8 08:31:04 UTC 2012)
Copyright (C) 2002-2011 Novell, Inc, Xamarin, Inc and Contributors. www.mono-project.com
    TLS:           __thread
    SIGSEGV:       altstack
    Notifications: epoll
    Architecture:  amd64
    Disabled:      none
    Misc:          softdebug
    LLVM:          supported, not enabled.
    GC:            Included Boehm (with typed GC and Parallel Mark)

$ PATH=/opt/mono-2.10.9/bin:$PATH /opt/mono-2.10.9/bin/xsp4
xsp4
Listening on address: 0.0.0.0
Root directory: /home/tvjames
Listening on port: 8080 (non-secure)
Hit Return to stop the server.
```

Good luck!

Coming in part 2: Getting supervisord to keep our xsp processes running

