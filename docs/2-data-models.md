---
redirect_from: /docs/2-data-models.html
---

# Data Models

There are four models that are important to Caffeinate.

## Campaign

This is a database record that ties everything together. It contains a `name` (string) and a unique `slug` (string).

## CampaignSubscription

This ties a database record to a Campaign. It has the following schema:

```
caffeinate_campaign
subscriber (polymorphic)
user (polymorphic, optional)
token (string, unique)
ended_at (datetime)
unsubscribed_at (datetime)
```

It has two relations that are similar, but different: subscriber, and user. 

The concept here is that a User may have many objects that are relevant to warrant their own Campaign. For this reason, 
we include this as a default.

For example, if you are Netflix and have a `Subscription` and a `WatchHistory` object. If a user does not finish watching
a video, you may want to remind them that they can finish watching it. If their subscription lapses, you may want to also 
remind them in a separate campaign.

So, you'd have separate `Caffeinate::CampaignSubscription` objects where the `subscriber` is the relevant `Subscription` 
object or the `WatchHistory` object, and the `user` is the user.

## Mailing

A mailing is associated to a `Caffeinate::CampaignSubscription`, and a `Caffeinate::Campaign` through the `Caffeinate::CampaignSubscription`. It also has the following attributes:

```
send_at (datetime)
sent_at (datetime)
skipped_at (datetime)
mailer_class (string)
mailer_action (string)
```

A Mailing record is created when we create a new `Caffeinate::CampaignSubscription` object. We create them based on the 
drips we define in our Campaign (not `Caffeinate::Campaign`) resource.

## Dripper

A Dripper ties a `::Caffeinate::Campaign` to a mailer, and all the logic between.
 
Onto [Dripper Customization](3-dripper-customization.md).
