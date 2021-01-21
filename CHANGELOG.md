# Changelog

Important additions/changes/removals will appear here.

## [Unreleased]

### Added
* `Caffeinate::Mailing#send_at` column must is `not null`
* `Caffeinate::Mailing.unsent` reflects `Caffeinate::Mailing` records where `Caffeinate::CampaignSubscription` is active
* `Caffeinate::Campaign` now has an `active` scope 

### Changed
* Better documentation

### Removed
* Auto-subscribe functionality

## v0.14 (January 18, 2021)

### Added
* This changelog
* Add Rails migration version when installing Caffeinate
* Ability to bail on a mailing in a `before_drip` callback ([3643dd](https://github.com/joshmn/caffeinate/commit/3643ddb6bd6d7456767ab9ec74f6e3a3d6c7ec5d#diff-c799b6345442d9f2975dee1b944b945d491174e7f39f3440d2c48b5ba4d31825))

### Changed
* Drip doesn't get evaluated if `before_drip` returns false 
