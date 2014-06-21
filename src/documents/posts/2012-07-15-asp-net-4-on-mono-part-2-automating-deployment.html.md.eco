---
author: tvjames
comments: true
date: 2012-07-15 11:34:05+00:00
layout: post
slug: asp-net-4-on-mono-part-2-automating-deployment
title: ASP.net 4 on Mono – Part 2 – Automating deployment
wordpress_id: 248
---

In [ASP.net 4 on Mono – Part 1 – Installing Mono](http://www.thomasvjames.com/2012/07/asp-net-4-on-mono-part-1-installing-mono/) I showed how mono could be downloaded, build and installed into a debian instance.

This part of this series is to go through the nuts & bolts of automatically deploying an asp.net 4 application to our mono installed server.

I've made use of the following tools for this:





  * [Fabric](http://fabfile.org) (again, for automation)


  * [Supervisor](http://supervisord.org/) to keep our xsp4 processes running 


  * [Nginx](http://nginx.org/) will manage our frontend





## Some background



The goal of this post is to be able to deploy a local asp.net web application to our remote server with a single command.

For this to work a convention for our apps needs to be employed. I went with the following:

Going with our (heroku inspired name) example app: `falling-star-3455`





  * Base directory for app deployed apps: `/srv/apps`


  * Each app will have its own directory: `/srv/apps/falling-star-3455`


  * Within each app directory we'll have the following:



    * `/bin` any binaries / scripts that we need


    * `/conf` external configuration, this is where we'll store the nginx & supervisor config


    * `/app` directory for our application


    * `/repo` this will be our git repo, for a future post


    * `/logs`


    * `/public_html` static files for nginx to serve





We also require a more recent version of `nginx` that what's in the debian repository, so we'll grab it from backports.

Finally, we'll be running each app using its own unix user account, this is for isolation of resources. Each account will share the same primary group `app` and be a member of the `www-data` group.



## The Process



Our fabric task will accept the following as arguements, allowing for some basic configuration at the command line:





  * `appname`: the name we'll use to control the app, forms the base directory name 


  * `srcfolder`: the local directory that contains our asp.net application


  * `baseport`: base port number our xsp instances will listen on


  * `numbackend`: number of backend xsp processes we want (defaults to 1)


  * `staticfolder`: optional local directory containing the static files for nginx to serve


  * `cname`: optional dns cname for the application


  * `suffix`:  the optional internall dns suffix to the appname



The fabric script's first task is to create the `appname` as a local user if it doesn't already exist and to prepare the remote server directory structure. The folders are set to SGID so that new files created are owned by the directory owner `www-data`.

Fabric's built in template & file upload process is then used to push to the remote server three files.





  * `nginx.conf`


  * `supervisord.conf`


  * `daemon` (uploaded to `/bin`) which is used by supervisord to start xsp as supervisor doesn't support environment variable expansion when starting commands, which means we cant use dynamic ports without it. 



The template engine is provided with most of the variables needed to write the files including appname, directories and path to mono.

The files are set to be owned by root so that they are unable to be altered by the running app process.

The local app & static files are then pushed to the appropriate directories, then permissions updated.

Finally we wire up the configuration for supervisord & nginx that we uploaded earlier with a symbolic link for each and reload the configuration for each.

Supervisor:


    
    <code>supervisorctl reread
    supervisorctl update
    supervisorctl restart falling-star-3455:*
    </code>



Nginx:


    
    <code>nginx -s reload
    </code>





## Get the code



[The fabric tasks](https://gist.github.com/3116218)

[templates/apps/nginx.conf](https://gist.github.com/3116339)

[templates/apps/supervisord.conf](https://gist.github.com/3116342)

[templates/apps/daemon](https://gist.github.com/3116345)

