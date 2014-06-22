---
author: tvjames
comments: true
date: 2013-09-29 10:40:56+00:00
layout: post
slug: create-a-windows-base-box-for-vagrant
title: Create a windows base box for vagrant
wordpress_id: 307
---

Using puppet on windows, one thing has been missing for me, being able to iterate quickly with vagrant. There are a number of articles out there that detail a the steps required to create your own windows base box for vagrant, but unfortunately they're a whole bunch of manual steps, which doesn't gel too well with working with an automated environment. So this is my attempt to distil down the steps into as few manual ones as possible.

This has all been tested using the publicly available [Windows Server 2008 R2 evaluation VHD for Hyper-V](http://www.microsoft.com/en-au/download/details.aspx?id=16572).

The end goal being a vagrant base box that:

  * Includes puppet
  * Has all the necessary setup performed via powershell
  * vagrant up works as expected

You will need the latest versions of the following installed as well:

  * [VirtualBox](https://www.virtualbox.org/)
  * VirtualBox Extensions
  * [Vagrant](http://www.vagrantup.com/)
  * [vagrant-windows](https://github.com/WinRb/vagrant-windows) plugin to vagrant (`vagrant plugin install vagrant-windows`)

The Hyper-V VHD unfortunately doesn't work as-is with the default VirtualBox setting used when creating a new VM, so use the following bash script to setup the needed VirtualBox VM. The main change required is connecting the VHD to an IDE Controller not the default SATA one the wizard will create.

<gist>tvjames/6750255?file=Vagrantfile</gist>

<gist>tvjames/6750255?file=virtualbox.sh</gist>

Save the gist locally as `virtualbox.sh` in the directory you want to use as your working folder, the gist will do the following:

  * Boot VM via ./virtualbox.sh script (note, only tested on a mac)
  * Login as Administrator/Pass@word1
  * Allow installation to complete, consent to the reboot
  * Login as Administrator/Pass@word1
  * Set the Timezone
  * Install the VirtualBox Guest Additions
  * Run the vagrant_prepare.ps1 gist from the command shell

```
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://gist.github.com/tvjames/6750255/raw/33f3a553663b6b6ace77f1eb11ee23d4c58449fd/vagrant_prepare.ps1'))"
```

Once the preparation script is complete:

  * Activate Windows for 180 days of use.
  * Reset password expiry on administrator
  * Shutdown the VM so that a vagrant base box can be created

Back in the terminal window where `virtualbox.sh` was run from, execute the following, it will take a while:

```
NAME=$(basename -s .vhd *.vhd)
VBOX=$(VBoxManage showvminfo "$NAME" | grep "Config file" | cut -d : -f 2 -s | sed 's/^ *//g')
vagrant package --base "${VBOX}" --output windows-server-2008-r2-eval.box
vagrant box add windows-server-2008-r2-eval windows-server-2008-r2-eval.box
```

If you are rebuilding an earlier box, you'll need to remove the exiting one before running the above commands:

```
vagrant box remove windows-server-2008-r2-eval
```

To create your new windows vagrant instance:

```
vagrant init windows-server-2008-r2-eval
# alter Vagrant file according to https://github.com/WinRb/vagrant-windows
vagrant up
```

You now have a fully functioning vagrant controlled windows box for the next 180 days, with the puppet provisioner baked in.

Enjoy!

<gist>tvjames/6750255</gist>
