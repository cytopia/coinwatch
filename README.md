# coinwatch

**[Usage](#usage)** |
**[Screenshots](#screenshots)** |
**[Features](#features)** |
**[Configuration](#configuration)** |
**[Options](#options)** |
**[API](#api)** |
**[Requirements](#requirements)** |
**[License](#license)**

[![Build Status](https://travis-ci.org/cytopia/coinwatch.svg?branch=master)](https://travis-ci.org/cytopia/coinwatch)
[![Release](https://img.shields.io/github/release/cytopia/coinwatch.svg)](https://github.com/cytopia/coinwatch/releases)

Coinwatch is a low-dependency python-based console client client to keep track of your crypto trades and easily let's you see if you are winning or losing.

All you have to do is enter all of your purchases: **When**, **How many** coins and **price per coin**. Then each time you launch `coinwatch`, it will show your current status and will make you happy or sad.


## Usage
```bash
# Default run
coinwatch

# Specify different profile/config
coinwatch -c ~/path/to/conf.yml

# Output in text mode
coinwatch -t

# Alternative number format
coinwatch -f

# Text output wrapped in watch
watch --interval=10 'coinwatch -t'
```


## Screenshots

The example shows the usage of an alternative configuration file.
![normal](screenshot/screen-01.png)

The example shows an alternative number format
![normal](screenshot/screen-03.png)

The example shows how it looks in text mode
![normal](screenshot/screen-02.png)

The example shows coinwatch wrapped into `watch` and refresh every 10 seconds.
![watcher](screenshot/screen-04.png)


## Features

* Keep track of all of your trades
* Trades are grouped by each crypto currency
* Different trading profiles can be used by specifying different configuration files
* Pure text-based output is available for further processing in other tools


## Configuration
When starting `coinwatch` for the first time, it will create a default configuration file in `~/.config/coinwatch/config.yml` with no trades to watch. To get a quick overview, have a look at the [example config](example/config.yml).

Configuration is done in yaml format. If you have never heard about yaml before, have a look at its official example: http://yaml.org/start.html

### Structure
The configuration file is build up like this:
```yml
trades:
  # CURRENCY_ID is found by looking up the 'id' key from
  # https://api.coinmarketcap.com/v1/ticker/?limit=0
  CURRENCY_ID:  # <-- [array]       Each currency will hold a list of trades
    - amount:   # <-- [decimal]     How many coins for that currency were bought
      price:    # <-- [decimal]     Price for 1 coin of that currency
      date:     # <-- [yyyy-mm-dd]  When was that bought
```

### Example
An example file could look like this. It shows two bitcoin trades, one ethereum trade and an empty place holder for iota. When specifying an empty array, it serves only as a reminder for you to fill that out later and will not be shown in the stats.
```yml
trades:
  bitcoin:
    - amount:  5.323
      price:   10100.52
      date:    2017-12-05
    - amount:  0.001
      price:   110323.54
      date:    2018-01-27
  ethereum:
    - amount:  20
      price:   1070
      date:    2017-12-05
  # Note in this case 'iota' is defined as an empty array
  # and will not be shown in the stats.
  iota: []
```
The following does not show any trades, it might however serve as a reminder for you to actually trade later and already have that info present:
```yml
trades:
  bitcoin: []
  ripple:  []
  cardano: []
  iota:    []
  qtum:    []
  omisego: []
```


## Options
This shows the output of `coinwawtch -h`.
```bash
Usage: coinwatch [-vhctf]
       coinwatch [--version] [--help] [--config <path>] [--text] [--format]

coinwatch is a low-dependency python[23] client to keep track of your crypto trades
and easily lets you see if you are winning or losing.

OPTIONS:
    -v, --version  Show version and exit
    -h, --help     Show this help dialog and exit
    -c, --config   Specify path of an alternative configuration file.
    -t, --text     Do not display colors. Text mode is designed to use the
                   output of this program as input for other programs. Such as:
                   $ watch --interval=10 'coinwatch -t'
    -f, --format   Alternative format for displaying large numbers.
                   Try it out, might be more readable.

NOTE:
    No financial aid, support or any other recommendation is provided.
    Trade at your own risk! And only invest what you can effort to lose.

API:
    Currently supported remote price and coin APIs are:
      - coinmarketcap

CONFIGURATION:
    When starting coinwatch for the first time a base configuration file will be
    created in ~/.config/coinwatch/config.yml.
    You should edit this file and add your trades:
      - What currency
      - When bought
      - How much bought
      - Price for 1 coin of currency at that date
```


## API

Currently supported remote API's are:
  - [coinmarketcap](https://api.coinmarketcap.com/v1/ticker/?limit=0)


## Requirements

`coinwatch` itself requires `PyYaml`. Apart fromt that, only one of the following Python versions is required:

* Python 2.7 (requires `future` for Python 3 compat)
* Python 3.2
* Python 3.3
* Python 3.4
* Python 3.5
* Python 3.6


## License

**[MIT License](LICENSE.md)**

Copyright (c) 2018 [cytopia](https://github.com/cytopia)
