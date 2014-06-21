---
author: tvjames
comments: true
date: 2012-11-12 08:20:08+00:00
layout: post
slug: loading-tenant-databases-on-ravendb-startup
title: Loading tenant databases on RavenDB startup
wordpress_id: 265
categories:
- Development
tags:
- ravendb
---

<blockquote>
  Note: this applies to build 2139 and above of RavenDB
</blockquote>



One of the ways RavenDB conserves resources is to only load tenant databases that are in use. When the RavenDB process is start/restarted this means that the in-use databases are only loaded when the first request is received. This can result in timeouts in the client if your database is large, like mine, and takes more than 30 seconds to load.

Thanks to Oren via the mailing list, from build 2139 there is now a way to implement global startup hooks. This allows us to start the tenant databases as soon as RavenDB is up-and-running.

Be warned, the global startup hooks are implemented synchronously which means that if what you're loading/running takes considerable time this will delay the startup of RavenDB. I recommend using async calls to allow normal RavenDB startup to continue. This is especially important if you have multiple startup hooks.

Anyway, on to the code, to create a startup hook all that is required is implementing the IServerStartupTask interface in Raven.Abstractions.Extensions and placing the resulting class library in the RavenDB/Plugins folder. Restart RavenDB and you're off.

I had to do a dig of digging to figure out how to implement the load database on startup hook so this code shouldn't be considered best practice, YMMV, but it worked for me.


    
    <code>using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;
    using Raven.Abstractions.Data;
    using Raven.Abstractions.Extensions;
    using Raven.Database;
    using Raven.Database.Plugins;
    using Raven.Database.Server;
    
    namespace Plugins
    {
        public class LoadDatabaseOnServerStartupTask : IServerStartupTask
        {
            private const string DATABASE_NAME = "MyDatabase";
    
            public void Execute(HttpServer server)
            {
                // wait for the system database
                server.GetDatabaseInternal("System")
                      .ContinueWith(_ => server.GetDatabaseInternal(DATABASE_NAME));
            }
        }
    }
    </code>



This is just a simple example and without much more effort can be adapted to read a list of databases to load from a configuration document in the _System_ database. Don't forget logging as well… improvements welcome :)

Combine this with a much longer idle timeout and you're tenant database will available just after RavenDB starts, ready to serve requests.

