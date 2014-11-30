# Necromancer
[![Gem Version](https://badge.fury.io/rb/necromancer.png)][gem]
[![Build Status](https://secure.travis-ci.org/peter-murach/necromancer.png?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/peter-murach/necromancer.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/peter-murach/necromancer/badge.png)][coverage]

[gem]: http://badge.fury.io/rb/necromancer
[travis]: http://travis-ci.org/peter-murach/necromancer
[codeclimate]: https://codeclimate.com/github/peter-murach/necromancer
[coverage]: https://coveralls.io/r/peter-murach/necromancer

> Conversion from one object type to another with a bit of black magic.

**Necromancer** provides independent type conversion component for [TTY](https://github.com/peter-murach/tty) toolkit.

## Features

* Simple and expressive API
* Ability to specify own converters
* Support conversion of custom defined types

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'necromancer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install necromancer

## Contents

* [1. Usage](#1-usage)
* [2. Interface](#2-interface)
  * [2.1 convert](#21-convert)
  * [2.1 can?](#22-can)
* [3. Converters](#3-converters)

## 1. Usage

**Necromancer** requires you to instatiate it like so:

```ruby
converter = Necromancer.new
```

Once initialize **Necromancer** knows how to handle numerous conversions.

For example, to convert a string to a range type:

```ruby
converter.convert('1-10').to(:range)  # => 1..10
```

In order to handle boolean conversions:

```ruby
converter.convert('t').to(:boolean)   # => true
```

or get array elements into numeric type:

```ruby
converter.convert(['1', '2.3', '3.0']).to(:numeric)  # => [1, 2.3, 3.0]
```

However, if you want to tell **Necromancer** about source type use `from`:

```ruby
converter.convert(['1', '2.3', '3.0']).from(:array).to(:numeric) # => [1, 2.3, 3.0]
```

## 2. Interaface

### 2.1 convert

### 2.2 can?

To verify that a a given conversion can be handled by **Necormancer** call `can?` with the `source` and `target` of the desired conversion.

```ruby
converter = Necromancer.new
converter.can?(:string, :integer)   # => true
converter.can?(:unknown, :integer)  # => false
```

## 3. Converters

### 3.1 Custom

### 3.2 Array

```ruby
converter.convert(['1', '2.3', '3.0']).to(:numeric)
```

```ruby
converter.convert(['1', '2.3', '3.0']).from(:array).to(:numeric)
```

Raises error when in strict mode

```ruby
converter.convert(['1', '2.3', false]).from(:array).to(:numeric)
# => Necromancer::ConversionError: false cannot be converter to numeric value
```

Returns value when in non strict mode

```ruby
converter.convert(['1', '2.3', false]).from(:array).to(:numeric)
# => [1, 2.3, false]
```

### 3.3 Range

### 3.4 Hash

```ruby
converter.convert({ x: '27.5', y: '4', z: '11'}).to(:numeric)
# => { x: 27.5, y: 4, z: 11}
```

## Contributing

1. Fork it ( https://github.com/peter-murach/necromancer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright (c) 2014 Piotr Murach. See LICENSE for further details.
