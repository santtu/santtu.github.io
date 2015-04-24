---
title: "Custom Termination Policy for Auto Scaling"
tagline: "Priority Order!"
tags: ["aws", "code", "javascript"]
---

While chatting with [Thomas Avasol](https://twitter.com/avasol) about
auto scaling group termination policies[^1] I got an idea on how to
implement custom termination policies for AWS auto scaling groups.

## Background

(Feel free to skip ahead if you are familiar with auto scaling groups
and termination policies.)

A bit of a background first: When an auto scaling group is scaled
*down*, an instance to be terminated needs to be picked. There are
sevaral policies to choose from: oldest/newest instance, oldest launch
configuration, closest to full instance hour and the default (most
complex) one. A customer gets to choose one of these and *that's
it*.

If none of these suited you, there are some optios available:

* Use termination protection to prevent some instances being picked up
  for down-scaling termination. (This has been recommended to me as
  one way by several AWS engineers.)

* Run your own down-scale scheduler in an instance. This would
  effectively implement the downscaling logic itself, but with your
  own custom twist for choosing instances to terminate.

I consider the first one almost a kludge — an it's a binary decider,
so more nuanced policies are impossible with it anyway — while the
second one has superb flexibility, it brings in a new potential SPOF
and maintenance burden. So neither is a perfect solution.

Oh, and **why** would you want a custom termination policy? Well…
maybe those instances host large caches, and you'd like to terminate
instances with the least filled caches? Or you are running batch jobs
from a queue, where some jobs run long and some short and when jobs
are drained you'd want terminate only instances without jobs?

<small>(You could run the downscale scheduler inside the auto scale
group, but that forces you to open the can of distributed worms
including leader worm election and all that. I would not want to go
down that road. It is much easier to instead run the scheduler in an
instance within an auto scale group set to one instance in size,
ensuring it'll get re-created. Either way, it requires an instance, a
thing that I'd like to avoid for smaller groups and simpler custom
termination policies.)</small>

## Idea &#128161;

Downscaling in an auto scaling group works when a CloudWatch alarm is
triggered, which in turn is set to trigger an scaling action that then
changes the desired instance count.

1. Now… alarms can also send notifications to SNS topics,

2. SNS topics can trigger Lambda functions,

3. Lambda functions can be assigned IAM roles, and Lambda functions
   can access all AWS API functionality that the IAM role allows,

4. **Ergo**, I can move the custom termination policy code to a Lambda
   function without needing to run a separate instance.

With my head humming I started hacking at it and got a
proof-of-concept version running already a few hours later.
**It <strike>is alive</strike> works!**

## Code

I'll tell you how to actually set up this in a while, but first,
here's the Lambda code.

<script src="https://gist.github.com/santtu/7e759d30f11dca78e3cf.js"></script>

It's a bit verbose. Using Underscore or Coffeescript surely would be
more readable and/or compact. I'm not really a Node.js developer which
probably also shows. This certainly is **not production quality** as
it makes quite a bit of assumptions and has hard-coded values in
it. *This is a proof-of-concept code!  Caveat emptor!*

The code is straightforward: `exports.handler` will get called, it'll
extract auto scale group name from the SNS notification, then iterate
over running instances in the group and fetch a *total time* value via
HTTP from these instances (a custom CloudWatch metric would do as
well), finally picking the instance with the lowest *total time*
value.

## Setup

The Lambda function above will not in itself yet do anything. To run
it, you need to first (assuming you already have auto scale group set
up):

1. Create IAM role with enough permissions to do auto scaling actions
2. Create the Lambda function
3. Create an SNS topic and add a subscription for it to call the Lambda
   function
4. Create CloudWatch alarms to send a notification to the SNS topic
   from above when you want a downscale to occur.

   **You will need multiple alarms set up** for multiples of your
   cooldown period. For example, if you want to downscale if average
   CPU load is less than 25% for 10 minutes, you'll have to set up the
   first alarm at 10 minutes, second one at 20 minutes, third at 30
   minutes up to the maximum number of your scaling group (see below
   for details why).

Done!

## Caveats

I ran into some limitations of Lambda and CloudWatch when working on
this:

* Lambda functions can access instances only via public IP addresses —
  `PrivateIpAddress` does not work. This is a bit of a security
  bother, so I'd actually suggest to push custom cloudwatch metrics
  from instances that the code would read without relying on public
  access.

  (I'd like to refer to Lambda functions in security groups directly
  and use internal IP addresses to access AWS resources.)

* I originally had the downscale handler set the triggering cloudwatch
  alarm to `INSUFFICIENT_DATA` state in a hope to make it re-trigger
  later again. It got stuck in a re-trigger race loop, getting
  repeatedly triggered (downscaling the group into 1 instance in one
  fell swoop).

* I could not figure out a way within AWS services to cause a delay in
  re-triggering the downscale handler. It is possible to have delay
  queues in SQS, but no way to trigger Lambda functions based on SQS
  messages. If there ever is a way to trigger Lambda functions from
  SQS messages (or route SQS messages to a SNS topic) then it would be
  possible for the handler to inspect the original alarm state after a
  cooldown period and requiring only a single alarm.

  (I'd like either a way to schedule Lambda call for later, to trigger
  Lambda functions via an SQS delay queue, or to specify to an alarm
  to retrigger after some cooldown delay if it is still in a trigger
  state.)

* [Lambda](http://aws.amazon.com/lambda/) is currently available only
  in US East, US West (Oregon) and EU West regions, which may limit
  its usefulness at the moment. On the other hand, it should become
  available in other regions soon-ish.

Note that auto scaling apparently has some internal logic that causes
it to inspect the alarm state after cooldown period, retriggering the
scaling action multiple times as needed. An alarm, however, will send
only a single notification to SNS topic, thus making the Lambda
function edge-triggered on the alarm. (Auto scaling magic turns that
into level-triggered action instead.)

Anyway that's it — please drop a comment below if you find this
useful!

----

[^1]: On 21st April 2015 at AWS Summit Stockholm, to be precise.
