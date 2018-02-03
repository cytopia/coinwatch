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

# Different columns and order
coinwatch -r "coin buyprice nowprice wealth invest profit"
coinwatch -r "coin date nowprice wealth profit percent"

# Specify sort and order
coinwatch -s profit -o desc

# Sort and group by name
coinwatch -s name -g name

# Disable colorized output
coinwatch -n

# Different table border
coinwatch -t ascii
coinwatch -t thin
coinwatch -t thick

# Alternative number format
coinwatch -h

# Text output wrapped in watch
watch --interval=10 'coinwatch -n'
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
# Configure coinwatch
config:
  # Specify the column to sort this table
  # Overwrite via -s <column>
  sort: name
  # Specify the sort order (asc or desc)
  # Overwrite via -o desc
  order: asc
  # Configure what columns to display and in what order.
  # To see all available columns view help: $ coinwatch --help
  # Columns specified via command line (-r) take precedence
  columns: name date buyprice diffprice nowprice amount invest wealth profit percent
  # Specify your table border style
  # Available values: thin, thick and ascii
  # Use ascii if you want to further process the output of this application
  table: thin

# Configure your purchases
trades:
  # CURRENCY_ID is found by looking up the 'id' key from
  # https://api.coinmarketcap.com/v1/ticker/?limit=0
  CURRENCY_ID:  # <-- [array]       Each currency will hold a list of trades
    - amount:   # <-- [decimal]     [1] How many coins for that currency were bought
      invest:   # <-- [decimal]     [1] How much money in total was invested
      price:    # <-- [decimal]     [1] Price for 1 coin of that currency
      date:     # <-- [yyyy-mm-dd]  When was that bought
```

**`[1]`** `amount`, `invest` and `price` at the same time? Yes that's right there is duplication, however only always two of those three can be specified at the same time. This gives the possibility to record you trades in three different ways:

#### Option-1: amount and invest
How many coins did you buy and how much money in total did you spent on that?

This option is most useful when having done a real purchase. Enter the total money spent and the coins received. That way you don't have to calculate any market fees or transaction fees yourself.
```yml
# Bought 0.4 coins
# Total cost of that: 3742.35 $
trades:
  bitcoin:
    - amount: 0.4
      invest: 3742.35
```
#### Option-2: amount and price
How many coins did you buy and how much did one coin cost?

This option is most useful when doint dry-run trades - *What would have happened if*. Enter how many coins you had bought at what price per coin.
```yml
# Bought 0.4 coins
# 1 Bitcoin had a price of: 9355.875 $
trades:
  bitcoin:
    - amount: 0.4
      price:  9355.875
```
#### Option-3: invest and price
How much money in total did you spend and how much did one coin cost?

This option is most useful when doint dry-run trades - *What would have happened if*. Enter how much money you would have spent and what the price per coin was.
```yml
# Total cost of that: 3742.35 $
# 1 Bitcoin had a price of: 9355.875 $
trades:
  bitcoin:
    - invest: 3742.35
      price:  9355.875
```

### Example
An example file could look like this. It shows three bitcoin trades (with each different option to specify your purchases), one ethereum trade and an empty place holder for iota. When specifying an empty array, it serves only as a reminder for you to fill that out later and will not be shown in the stats.
```yml
trades:
  bitcoin:
    - amount: 0.4
      invest: 3742.35
      date:   2017-12-03
    - amount: 0.4
      price:  9355.875
      date:   2017-12-04
    - invest: 3742.35
      price:  9355.875
      date:   2017-12-05
  ethereum:
    - amount: 20
      price:  1070
      date:   2017-12-05
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
This shows the output of `coinwawtch --help`.
```bash
Usage: coinwatch [-crtnhv]
       coinwatch [--help]
       coinwatch [--version]

coinwatch is a low-dependency python[23] client to keep track of your crypto trades
and easily lets you see if you are winning or losing.

OPTIONS:
  -c, --config   Specify path of an alternative configuration file.
                 Examples:
                   -c path/to/conf.yml
  -r, --row      Specify the order and columns to use in a row.
                 In case you dont need all columns to be shown or want
                 a different order of columns, use this argument to specify it.
                 Examples:
                   -r "coin date profit percent"
                   -r "coin buyprice nowprice amount wealth"
                 Default:
                   -r "coin date buyprice nowprice amount invest wealth profit percent"
  -s, --sort     Specify the column name to sort this table.
                 See above for available columns.
                 The table can also be sorted against columns that are not displayed.
                 The default is: 'name'
  -o, --order    Specify the sorting order.
                 Valid orders: 'asc' and 'desc'.
                 The default order is 'asc'.
  -g, --group    Group by column name (visually).
                 Grouping is applied after sorting and only equal vertical rows of
                 the specified group column are grouped.
  -t, --table    Specify different table border.
                 Available values: 'thin', 'thick' and 'ascii'.
                 The default is 'thin'.
                 In case you need to process the output of this tool use 'ascii'.
                 Examples:
                   -t thin
                   -t thick
                   -t ascii
  -n, --nocolor  Disable shell colors. This is useful if you want to further
                 process the output of this program.
  -h, --human    Alternative human readable number format.
  -v, --verbose  Be verbose.

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
