# Changelog 

## Unreleased

Nothing, yet. 

## Version 1.0.0 (Sep 04, 2023)

### Added

* A stable version.

## Version 0.11.1 (Sep 04, 2023)

### Added
* Skeleton loader for feedback during loading

## Version v0.11.0 (Aug 19, 2023)

### Added
* Drag and drop for a date range on the stats line chart
  - Plausible doesn't have this so I feel less guilty about the project now
* World map now shows 
* Free-choice selection for UTM tags when filtering

### Changed
* Sublinks for a container now are highlighted on load 
* Styling for properties select container is now consistent with other select 
* Better "active link" handling
* DRYed up the links

### Fixed
* Bug when filtering by goal
* New combobox not taking into consideration other filters not yet applied

## Version 0.10.1 (Aug 17, 2023)

### Fixed
* Values loading in combobox for goals were invalid 

## Version 0.10.0 (Aug 17, 2023)

### Fixed 
* Active link clicks become active if you click a child element
* Persist the interval of the graph when changing graphs

### Added
* Naive window function for graphs
  - ideally this would be done in the database
* Naive date comparison
  - still has some quirks, but nothing showstopping:
    - sometimes the window function doesn't cover the entire span
    - no "lining up" dates (yet)
* Configurable interval for realtime
  - was 30 seconds by default
* Custom properties table
* Custom property searching
  - currently only supports searching one key at a time
* Better handling of null values in a query 
  - will now use the Ransack is_null and is_not_null 
* New combobox/select component 
  - it's just better 
* When closing a filter modal, it'll revert the original values if you didn't click apply 

### Changed
* How tables with non-standard rows are rendered

### Removed
* SlimSelect 

## Version 0.91 (Aug 08, 2023)

### Fixed
* Route-based queries were checking for `url` or (`action` and `controller`) in the Event properties; this should be `action` or `controller` by default 
* Show an active class for the selected chart 
* Fix some queries with hard-coded table names 

## Version 0.90 (Aug 08, 2023)

### Fixed 
* If the interval was about 30 days, the select would include the incorrect values
* When searching by referring domain, the query would error out because the column was ambiguous 

## Added
* Filtering by goals
* More consistent styling
* Better filtering experience
* Filters are now created at runtime and you can setup your own 
  * To officially setup your own, you're going to need to bring your own controller, but this is a first step.

## Version 0.82

### Added
* Began work on querying by properties 

### Changed
* Removed dependency on `CurrentAttributes`
  * this was a lazy man's RequestStore for one attribute and instead we'll just send it with the decorator
* Default period is now 30d, was MTD
* Simplified the filters
* All front-facing queries now live in a query object
  * makes exporting easier 
* Add CSV export 
* Tweaked the active link controller
* Reworked the table components
* Styling on line chart now reflects the DaisyUI theme

### Fixed 
* Views/visit returning NaN 

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
