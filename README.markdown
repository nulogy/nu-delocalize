# nu-delocalize

[![Build Status](https://travis-ci.org/nulogy/nu-delocalize.svg?branch=master)](https://travis-ci.org/nulogy/nu-delocalize)

delocalize provides localized date/time and number parsing functionality for Rails.

## Compatibility

This gem requires the following versions:

* Ruby >= 2.1.10 (Ruby >= 1.9.2 *should* work but isn't officially supported)
* Rails >= 4.1 (earlier versions including probably even Rails 1 *should* work but aren't officially supported)

Check [the Travis configuration](https://github.com/nulogy/nu-delocalize/blob/master/.travis.yml) in order to see which configurations we are testing.

## Installation

You can use delocalize as a gem from [GitHub](https://github.com/nulogy/nu-delocalize)

### Rails 4 and above

To use delocalize, put the following gem requirement in your `Gemfile`:

```ruby
gem "delocalize", git: "https://github.com/nulogy/nu-delocalize.git"
```

## What does it do? And how do I use it?

Delocalize, just as the name suggest, does pretty much the opposite of localize.

In the grey past, if you want your users to be able to input localized data, such as dates and numbers, you had to manually override attribute accessors:

```ruby
def price=(price)
  write_attribute(:price, price.gsub(',', '.'))
end
```

You also had to take care of proper formatting in forms on the frontend so people would see localized values in their forms.

Delocalize does most of this under the covers.

### Models

TODO

### Views

TODO

### Locale setup

In addition to your controller setup, you also need to configure your locale file(s). If you intend to use delocalize, you probably have a working locale file anyways. In this case, you only need to add two extra keys: `date.input.formats` and `time.input.formats`.

Assuming you want to use all of delocalize's parsers (date, time, number), the required keys are:
* number.format.delimiter
* number.format.separator
* date.input.formats
* time.input.formats
* date.formats.SOME_FORMAT for all formats specified in date.input.formats
* time.formats.SOME_FORMAT for all formats specified in time.input.formats

```yml
de:
  number:
    format:
      separator: ','
      delimiter: '.'
  date:
    input:
      formats: [:default, :long, :short] # <- this and ...

    formats:
      default: "%d.%m.%Y"
      short: "%e. %b"
      long: "%e. %B %Y"
      only_day: "%e"

    day_names: [Sonntag, Montag, Dienstag, Mittwoch, Donnerstag, Freitag, Samstag]
    abbr_day_names: [So, Mo, Di, Mi, Do, Fr, Sa]
    month_names: [~, Januar, Februar, März, April, Mai, Juni, Juli, August, September, Oktober, November, Dezember]
    abbr_month_names: [~, Jan, Feb, Mär, Apr, Mai, Jun, Jul, Aug, Sep, Okt, Nov, Dez]
    order: [ :day, :month, :year ]

  time:
    input:
      formats: [:long, :medium, :short, :default, :time] # <- ... this are the only non-standard keys
    formats:
      default: "%A, %e. %B %Y, %H:%M Uhr"
      short: "%e. %B, %H:%M Uhr"
      long: "%A, %e. %B %Y, %H:%M Uhr"
      time: "%H:%M"

    am: "vormittags"
    pm: "nachmittags"
```

For dates and times, you have to define input formats which are taken from the actual formats. The important thing here is to define input formats sorted by descending complexity; in other words: the format which contains the most (preferably non-numeric) information should be first in the list because it can produce the most reliable match. Exception: If you think there most complex format is not the one that most users will input, you can put the most-used in front so you save unnecessary iterations.

**Be careful with formats containing only numbers: It's very hard to produce reliable matches if you provide multiple strictly numeric formats!**

### Contributors and Copyright

[Here](https://github.com/nulogy/nu-delocalize/graphs/contributors) is a list of all people who ever contributed to delocalize.

Copyright (c) 2009-2015 Clemens Kofler <clemens@railway.at>
<http://www.railway.at/>
Released under the MIT license
