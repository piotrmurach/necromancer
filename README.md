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
  * [2.2 from](#22-from)
  * [2.3 to](#23-to)
  * [2.4 can?](#24-can)
* [3. Converters](#3-converters)
  * [3.1 Custom](#31-custom)
    * [3.1.1 Using an Object](#311-using-an-object)
    * [3.1.2 Using a Proc](#312-using-a-proc)
  * [3.2 Boolean](#32-boolean)
  * [3.3 Range](#33-range)
  * [3.4 Array](#34-array)

## 1. Usage

**Necromancer** requires you to instatiate it like so:

```ruby
converter = Necromancer.new
```

Once initialized **Necromancer** knows how to handle numerous conversions and also add your custom type [converters](#3-converters).

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

**Necromancer** will perform conversions on the supplied object through use of `convert`, `from` and `to` methods.

### 2.1 convert

```ruby
converter.convert('1,10').to(:range)  #  => 1..10
```

### 2.2 from

### 2.3 to

To convert objects between types, **Necromancer** provides several target types. The `to` method allows you to pass target as an argument to perform actual conversion:

```ruby
converter.convert('yes').to(:boolean)   # => true
```

The target parameters are:

* :array
* :boolean
* :float
* :integer
* :numeric
* :range
* :string

### 2.4 can?

To verify that a a given conversion can be handled by **Necormancer** call `can?` with the `source` and `target` of the desired conversion.

```ruby
converter = Necromancer.new
converter.can?(:string, :integer)   # => true
converter.can?(:unknown, :integer)  # => false
```

## 3. Converters

**Necromancer** flexibility means you can register your own converters or use the already defined types.

### 3.1 Custom

#### 3.1.1 Using an Object

Firstly, you need to create a converter that at minimum requires to specify `call` method that will be invoked during conversion:

```ruby
UpcaseConverter = Struct.new(:source, :target) do
  def call(value, options)
    value.upcase
  end
end
```

Then you need to specify what type conversions this converter will support. For example, `UpcaseConverter` will allow a string object to be converted to a new string object with content upper cased. This can be done:

```ruby
upcase_converter = UpcaseConverter.new(:string, :upcase)
```

**Necromancer** provides the `register` method to add converter:

```ruby
converter = Necromancer.new
converter.register(upcase_converter)   # => true if successfully registered
```

Finally, by invoking `convert` method and specifying `:upcase` as the target for the conversion we achieve the result:

```ruby
converter.convert('magic').to(:upcase)   # => 'MAGIC'
```

#### 3.1.2 Using a Proc

Using a Proc object you can create and immediately register a converter. You need to pass `source` and `target` of the conversion that will be used later on to match the conversion. The `convert` allows you to specify the actual conversion in block form. For example:

```ruby
converter = Necromancer.new

converter.register do |c|
  c.source= :string
  c.target= :upcase
  c.convert = proc { |value, options| value.upcase }
end
```

Then by invoking the `convert` method and passing the `:upcase` conversion type you can transform the string like so:

```ruby
converter.convert('magic').to(:upcase)   # => 'MAGIC'
```

### 3.2 Boolean

The **Necromancer** allows you to convert a string object to boolean object. The `1`, `'1'`, `'t'`, `'T'`, `'true'`, `'TRUE'`, `'y'`, `'Y'`, `'yes'`, `'Yes'`, `'on'`, `'ON'` values are converted to `TrueClass`.

```ruby
converter.convert('yes').to(:boolean)  # => true
```

Similarly, the `0`, `'0'`, `'f'`, `'F'`, `'false'`, `'FALSE'`, `'n'`, `'N'`, `'no'`, `'No'`, `'off'`, `'OFF'` values are converted to `FalseClass`.

```ruby
converter.convert('no').to(:boolean) # => false
```

You can also convert an integer object to boolean:

```ruby
converter.convert(1).to(:boolean)  # => true
converter.convert(0).to(:boolean)  # => false
```

### 3.3 Range

```ruby
```

### 3.4 Array

The **Necromancer** allows you to transform string into an array object:

```ruby
converter.call('a, b, c')  # => ['a', 'b', 'c']
```

If the string is a list of separated numbers, they will be converted to their respective numeric types:

```ruby
converter.call('1 - 2 - 3')  # => [1, 2, 3]
```

You can also convert array containing string objects to array containing numeric values:

```ruby
converter.convert(['1', '2.3', '3.0']).from(:array).to(:numeric)
```

or simply:

```ruby
converter.convert(['1', '2.3', '3.0']).to(:numeric)
```

When in strict mode the conversion will raise a `Necromancer::ConversionTypeError` error like so:

```ruby
converter.convert(['1', '2.3', false], strict: true).from(:array).to(:numeric)
# => Necromancer::ConversionTypeError: false cannot be converted from `array` to `numeric`
```

However, in strict mode the value will be simply returned unchanged:

```ruby
converter.convert(['1', '2.3', false], strict: false).from(:array).to(:numeric)
# => [1, 2.3, false]
```

### 3.5 Hash

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
