---
author: tvjames
comments: true
date: 2012-10-11 11:10:32+00:00
layout: post
slug: ravendb-bulk-document-import-and-mapreduce-indexes
title: RavenDB, Bulk document import and MapReduce indexes
wordpress_id: 261
categories:
- Development
tags:
- ravendb
---

_Build 960 was used as the basis for the post and is my first opportunity to use RavenDB in a non-trivial way_

A recent project afforded me the opportunity to use a NoSQL backing store and given it was a .net solution RavenDB was the obvious first choice.

This project was to provide a new view over a number of years of already collected data and the data yet to be collected by that system. So for this to work it needed to be able to ingest the existing dataset. This was approximately 3 million documents, however it was later culled to about half that.

Given the nature of this project, providing aggregate views over the data was critical. These aggregate views provided a number of levels of granularity, from yearly, monthly through to hourly.

Based on everything I've read Raven should be able to gobble this task up and spit it out, and for the most part that was my experience but i've encountered a few gotchas along the way.

About the dataset I was using:

  * 3 Million < 1KB documents
  * Total size < 700MB uncompressed text
  * About 10GB in Raven including indexes
  * 5 MapReduce indexes that map over the entire dataset using a composite key

Importing the data, what I assumed would be a simple task turned out to be less than straight forward.

**TL;DR:** When importing large numbers of documents in bulk, initialise the indexes, use a large batch size and wait for indexes to be fresh between processing.

## The first attempt

This was the naive attempt, create the indexes and just bulk import the data as fast as the datastore could accept it. This initially appeared to work well with the data being imported quite quickly. Soon after the import completed the indexing process kicked into high gear and consumed the available resources of the machine and after about 45 minutes crashed with an out of memory exception. Close to 100% CPU usage was observed for some time after the crash.

## The second attempt

Believing that the indexing process was the culprit I attempted to split the process between loading the data and then applying the indexes. Once again the import process completed quickly and within about 45 minutes to an hour of the indexes being created the same out of memory issue was encountered. This occurred on both 32bit and 64bit systems (most initial testing was performed on a 32bit win2k8 r1 VM on hyper-v, later using a 64bit windows 7 laptop (4core, 6gb ram) and a win2k8 r2 64bit VM on hyper-v with 8gb ram.

As a stop-gap measure the import process was made interactive, pausing between batches of about 150k documents imported. The indexing process, CPU & memory utilisation was monitored until they returned to normal then the next batch was started. This yielded the most success allowing the import process to complete, indexes and all.

## Getting it stable

Based on the success of processing batches of documents then pausing between to allow the indexing process to complete. The final import process automated this, which resulted in a stable and repeatable import process that completed in an acceptable amount of time.

And some code:

    <code>var documentStore = …;
    while (iStillHaveDocumentsToImport) {
        ImportBatchOfDocumentsInto(documentStore);

        var staleIndexes = documentStore.DatabaseCommands.GetStatistics().StaleIndexes;
        while (staleIndexes.Length > 0) {
            Thread.Sleep(1000);

            staleIndexes = documentStore.DatabaseCommands.GetStatistics().StaleIndexes;
        }
    }
    </code>

