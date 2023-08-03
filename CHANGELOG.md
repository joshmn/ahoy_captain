# Changelog

## Unreleased

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
