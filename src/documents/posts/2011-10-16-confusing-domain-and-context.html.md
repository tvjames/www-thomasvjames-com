---
author: tvjames
comments: true
date: 2011-10-16 06:34:18+00:00
layout: post
slug: confusing-domain-and-context
title: Confusing Domain and Context?
wordpress_id: 182
categories:
- Development
- Professional
tags:
- coding
- opinion
---

[Never, never, never use String in Java (or at least less often)](http://codemonkeyism.com/never-never-never-use-string-in-java-or-at-least-less-often/)

This, now older, article evokes some passionate discussion about the use of domain classes, where to validate, when to validate and what to validate.

**TL;DR**

Simple validation: Checking the value’s correctness.

<blockquote>

>
> It belongs in the domain object. Developers need to be able to rely on the domain objects to be _correct_ but not validated. An incorrect domain object instance should never be allowed to exist.
>
>
</blockquote>

Full validation: Checking that the value is a real value.

<blockquote>

>
> Can only be performed when the context in which the object is being used is known and can be considered.
>
>
</blockquote>

* * *

I'd like to consider the argument of domain and context, in relation to domain classes and validation. On one side of the argument it is suggested that full validation exist in the domain object, while others promote the idea of a string with validation that occurs when it's required. Like most non-specific arguments I think the answer lies somewhere in the middle when context is considered.

A domain model should ensure that it is correct in the context of the problem domain. The domain object should be validated in the context in which it is used.

Take a simple example that was used about half way down the comments in the above article, starting from about this [comment by Lars D](http://codemonkeyism.com/never-never-never-use-string-in-java-or-at-least-less-often/#comment-85971).

    <code>// We have Order & OrderID classes
    OrderID oldId = order.getID(); // Really old order, "12-000021"
    OrderID newId = orderService.newID(); // New Format "123-33-232"
    OrderID external = new OrderID("some id");
    </code>

How do we know if we have a valid order number?

It can be assumed the top two are valid, but what about the external one?

Our end-user entered "some id" but the order numbers should be "123-45-678" thats not to say in the future "AB123-4566" may be valid, it's all dependent the context OrderID is used in.

    <code>OrderID invalid = new OrderID("");
    // Here the constructor should throw,
    // As this would mean a semantically invalid OrderID object
    </code>

Perhaps when we go retrieve the order, the order service will accept the "some id" OrderID as the key to this is that it _could_ be valid. It may not, but provided it doesn't break the internals of the order service it shouldn't matter. We could let the user know the order id entered isn't valid and this is where the context comes in.

When the end-user enters the value into a form on the application we know the _context_ and can, using this additional information, make an informed validation about _how_ the OrderID will be used.

It's impossible for the OrderID class to know this information, so it needs to accept all valid values that _could_ be an order id, not just those that _are_ valid order id values.

[Another commenter provides an excellent summary as well](http://codemonkeyism.com/never-never-never-use-string-in-java-or-at-least-less-often/#comment-226361).

<blockquote>

>
> The idea of responsibility-driven design is an old one, and I think one that’s often forgotten by people. It’s become second-nature to just pile features and functionality unto one class, under the convenient guise of YAGNI to belie a hidden sense of downright laziness.
>
>
</blockquote>

