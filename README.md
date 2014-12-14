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

## Motivation

Conversion between Ruby core types frequently comes up in projects but is solved by half-baked solutions. This library aims to provide an independent and extensible API to support a robust and generic way to convert between core Ruby types.

## Features

* Simple and expressive API
* Ability to specify own converters
* Ability to compose conversions out of simpler ones
* Support conversion of custom defined types
* Ability to specify strict conversion mode

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
  * [2.5 configure](#25-configure)
* [3. Converters](#3-converters)
  * [3.1 Array](#31-array)
  * [3.2 Boolean](#32-boolean)
  * [3.3 Hash](#33-hash)
  * [3.4 Numeric](#34-numeric)
  * [3.5 Range](#35-range)
  * [3.6 Custom](#36-custom)
    * [3.6.1 Using an Object](#361-using-an-object)
    * [3.6.2 Using a Proc](#362-using-a-proc)

## 1. Usage

**Necromancer** requires you to instatiate it:

```ruby
converter = Necromancer.new
```

Once initialized **Necromancer** knows how to handle numerous conversions and also allows you to add your custom type [converters](#35-custom).

For example, to convert a string to a [range](#34-range) type:

```ruby
converter.convert('1-10').to(:range)  # => 1..10
```

In order to handle [boolean](#32-boolean) conversions:

```ruby
converter.convert('t').to(:boolean)   # => true
```

To convert string to [numeric](#34-numeric) value:

```ruby
converter.convert('10e1').to(:numeric)  # => 100
```

or get [array](#31-array) elements into numeric type:

```ruby
converter.convert(['1', '2.3', '3.0']).to(:numeric)  # => [1, 2.3, 3.0]
```

However, if you want to tell **Necromancer** about source type use `from`:

```ruby
converter.convert(['1', '2.3', '3.0']).from(:array).to(:numeric) # => [1, 2.3, 3.0]
```

## 2. Interface

**Necromancer** will perform conversions on the supplied object through use of `convert`, `from` and `to` methods.

### 2.1 convert

For the purpose of divination, **Necromancer** uses `convert` method to turn source type into target type. For example, in order to convert a string into a range type do:

```ruby
converter.convert('1,10').to(:range)  #  => 1..10
```

Alternatively, you can use block:

```ruby
converter.convert { '1,10' }.to(:range) # => 1..10
```

### 2.2 from

To specify conversion source type use `from` method:

```ruby
converter.convert('1.0').from(:string).to(:numeric)
```

In majority of cases you do not need to specify `from` as the type will be inferred from the `convert` method argument and then appropriate conversion will be applied to result in `target` type such as `:numeric`. However, if you do not control the input to `convert` and want to ensure consistent behaviour please use `from`.

The source parameters are:

* :array
* :boolean
* :float
* :integer
* :numeric
* :range
* :string

### 2.3 to

To convert objects between types, **Necromancer** provides several target types. The `to` method allows you to pass target as an argument to perform actual conversion:

```ruby
converter.convert('yes').to(:boolean)   # => true
```

By default, when target conversion fails the orignal value is returned. However, you can pass `strict` as an additional argument to ensure failure when conversion cannot be performed:

```ruby
converter.convert('1a').to(:integer, strict: true)
# => raises Necromancer::ConversionTypeError
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

To verify that a given conversion can be handled by **Necromancer** call `can?` with the `source` and `target` of the desired conversion.

```ruby
converter = Necromancer.new
converter.can?(:string, :integer)   # => true
converter.can?(:unknown, :integer)  # => false
```

### 2.5 configure

You may set global configuration options on **Necromancer** instance by passing a block like so:

```ruby
Necromancer.new do |config|
  config.strict true
end
```

or calling `configure` method:

```ruby
converter = Necromancer.new
converter.configure do |config|
  config.copy false
end
```

Available configuration options are:

* strict - ensures correct types for conversion, by default `false`
* copy - ensures only copy is modified, by default `true`

## 3. Converters

**Necromancer** flexibility means you can register your own converters or use the already defined converters for such types as 'Array', 'Boolean', 'Hash', 'Numeric', 'Range'.

### 3.1 Array

The **Necromancer** allows you to transform arbitrary object into array:

```ruby
converter.convert(nil).to(:array)     # => []
converter.convert({x: 1}).to(:array)  # => [[:x, 1]]
```

In addition, **Necromancer** excels at converting `,` or `-` delimited string into an array object:

```ruby
converter.convert('a, b, c').to(:array)  # => ['a', 'b', 'c']
```

If the string is a list of `-` or `,` separated numbers, they will be converted to their respective numeric types:

```ruby
converter.convert('1 - 2 - 3').to(:array)  # => [1, 2, 3]
```

You can also convert array containing string objects to array containing numeric values:

```ruby
converter.convert(['1', '2.3', '3.0']).to(:numeric)
```

When in `strict` mode the conversion will raise a `Necromancer::ConversionTypeError` error like so:

```ruby
converter.convert(['1', '2.3', false]).to(:numeric, strict: true)
# => Necromancer::ConversionTypeError: false cannot be converted from `array` to `numeric`
```

However, in `non-strict` mode the value will be simply returned unchanged:

```ruby
converter.convert(['1', '2.3', false]).to(:numeric, strict: false)
# => [1, 2.3, false]
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

### 3.3 Hash

```ruby
converter.convert({ x: '27.5', y: '4', z: '11'}).to(:numeric)
# => { x: 27.5, y: 4, z: 11}
```

### 3.4 Numeric

**Necromancer** comes ready to convert all the primitive numeric values.

To convert a string to a float do:

```ruby
converter.convert('1.2a').to(:float)  #  => 1.2
```

Conversion to numeric in strict mode raises `Necromancer::ConversionTypeError`:

```ruby
converter.convert('1.2a').to(:float, strict: true) # => raises error
```

To convert a string to an integer do:

```ruby
converter.convert('1a').to(:integer)  #  => 1
```

However, if you want to convert string to an appropriate matching numeric type do:

```ruby
converter.convert('1e1').to(:numeric)   # => 10
```

### 3.5 Range

**Necromancer** is no stranger to figuring out ranges from strings. You can pass `,`, `-`, `..`, `...` characters to denote ranges:

```ruby
converter.convert('1,10').to(:range)  # => 1..10
```

or to create a range of letters:

```ruby
converter.convert('a-z').to(:range)   # => 'a'..'z'
```

### 3.6 Custom

In case where provided conversions do not match your needs you can create your own and `register` with **Necromancer** by using an `Object` or a `Proc`.

#### 3.6.1 Using an Object

Firstly, you need to create a converter that at minimum requires to specify `call` method that will be invoked during conversion:

```ruby
UpcaseConverter = Struct.new(:source, :target) do
  def call(value, options = {})
    value.upcase
  end
end
```

Inside the `UpcaseConverter` you have access to global configuration options by directly calling `config` method.

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

#### 3.6.2 Using a Proc

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

## Contributing

1. Fork it ( https://github.com/peter-murach/necromancer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright (c) 2014 Piotr Murach. See LICENSE for further details.
