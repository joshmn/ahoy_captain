# AhoyCaptain

<img src="logo.png" style="max-width:100px" />

A full-featured, mountable analytics dashboard for your Rails app, shamelessly inspired by Plausible Analytics, powered by the Ahoy gem.

## Notice

While this is fine to use in production, it was only built against a PostgreSQL instance.

## Some assumptions

Some hardcoded stuff as of writing; this will be more fully-featured in due time.

## Installation

### 1. Do the bundle

Drop it in:

```bash
$ bundle add ahoy_captain
```

### 2. Install it

```bash
$ rails g ahoy_captain:install
```

### 3. Star this repo

No, seriously, I need all the internet clout I can get.

### 4. Analyze your nightmares

If you have a large dataset (> 1GB) you probably want some indexes. `rails g ahoy_captain:migration`

## Features

* Top sources
* Top pages, landing pages, and exit pages
* UTM reporting
* Top locations, by countries, regions, and cities
* Top devices, by browser, OS, and device type
* Goal tracking
* Funnels
* Filter by:
    * Page
    * Location
    * Device type
    * OS
    * UTM tags

## Coming soon ™️

* Date comparison
* More filters
* CSV exports

## Contributors

This was built during the Rails Hackathon in July 2023 with [afogel](https://github.com/afogel) and [dnoetz](https://github.com/dnoetz).

## Contributions

Please and thank you in advance!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
