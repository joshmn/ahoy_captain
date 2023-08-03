# Changelog

## Unreleased

### Changed
* Removed dependency on `CurrentAttributes`
  * this was a lazy man's RequestStore for one attribute and instead we'll just send it with the decorator
* Default period is now 30d, was MTD

## Version 0.8

### Added

* Goals now support queries instead of just event names
* Stats graph/chart now supports changing intervals 
* The migration as mentioned in the readme 

### Fixed

* Fix visit and event query by properly merging the searches
  - https://activerecord-hackery.github.io/ransack/going-further/merging-searches/
  - this requires queries to specify the full table name 
* Rewrite bounce rate query
* Bug in visits chart 

### Changed

* Changed the configuration file to properly reflect method names 
* The background/progress bar on a goal (in the goals list) now reflects the conversion rate
  - before, this was relative to other goals

## Version 0.77

* Initial release and announcement thing
