# frozen_string_literal: true

require "set"

require_relative "../converter"
require_relative "boolean"
require_relative "numeric"

module Necromancer
  # Container for Array converter classes
  module ArrayConverters
    # An object that converts a String to an Array
    class StringToArrayConverter < Converter
      # Convert string value to array
      #
      # @example
      #   converter.call("a, b, c")  # => ["a", "b", "c"]
      #
      # @example
      #   converter.call("1 - 2 - 3")  # => ["1", "2", "3"]
      #
      # @api public
      def call(value, strict: config.strict)
        return [] if value.to_s.empty?

        if match = value.to_s.match(/^(.+?(\s*(?<sep>(,|-))\s*))+/)
          value.to_s.split(match[:sep])
        else
          strict ? raise_conversion_type(value) : Array(value)
        end
      end
    end

    class StringToBoolArrayConverter < Converter
      # @example
      #   converter.call("t,f,yes,no") # => [true, false, true, false]
      #
      # @param [Array] value
      #   the array value to boolean
      #
      # @api public
      def call(value, strict: config.strict)
        array_converter = StringToArrayConverter.new(:string, :array)
        array = array_converter.(value, strict: strict)
        bool_converter = ArrayToBooleanConverter.new(:array, :boolean)
        bool_converter.(array, strict: strict)
      end
    end

    class StringToIntegerArrayConverter < Converter
      # @example
      #   converter.call("1,2,3") # => [1, 2, 3]
      #
      # @api public
      def call(string, strict: config.strict)
        array_converter = StringToArrayConverter.new(:string, :array)
        array = array_converter.(string, strict: strict)
        int_converter = ArrayToIntegerArrayConverter.new(:array, :integers)
        int_converter.(array, strict: strict)
      end
    end

    class ArrayToIntegerArrayConverter < Converter
      # @example
      #   converter.call(["1", "2", "3"]) # => [1, 2, 3]
      #
      # @api public
      def call(array, strict: config.strict)
        int_converter = NumericConverters::StringToIntegerConverter.new(:string, :integer)
        array.map { |val| int_converter.(val, strict: strict) }
      end
    end

    # An object that converts an array to an array with numeric values
    class ArrayToNumericConverter < Converter
      # Convert an array to an array of numeric values
      #
      # @example
      #   converter.call(["1", "2.3", "3.0])  # => [1, 2.3, 3.0]
      #
      # @param [Array] value
      #   the value to convert
      #
      # @api public
      def call(value, strict: config.strict)
        numeric_converter = NumericConverters::StringToNumericConverter.new(:string, :numeric)
        value.map { |val| numeric_converter.(val, strict: strict) }
      end
    end

    # An object that converts an array to an array with boolean values
    class ArrayToBooleanConverter < Converter
      # @example
      #   converter.call(["t", "f", "yes", "no"]) # => [true, false, true, false]
      #
      # @param [Array] value
      #   the array value to boolean
      #
      # @api public
      def call(value, strict: config.strict)
        boolean_converter = BooleanConverters::StringToBooleanConverter.new(:string, :boolean)
        value.map { |val| boolean_converter.(val, strict: strict) }
      end
    end

    # An object that converts an object to an array
    class ObjectToArrayConverter < Converter
      # Convert an object to an array
      #
      # @example
      #   converter.call({x: 1})   # => [[:x, 1]]
      #
      # @api public
      def call(value, strict: config.strict)
        begin
          Array(value)
        rescue
          strict ? raise_conversion_type(value) : value
        end
      end
    end

    # An object that converts an array to a set
    class ArrayToSetConverter < Converter
      # Convert an array to a set
      #
      # @example
      #   converter.call([:x, :y, :x, 1, 2, 1])  # => <Set: {:x, :y, 1, 2}>
      #
      # @param [Array] value
      #   the array to convert
      #
      # @api public
      def call(value, strict: config.strict)
        begin
          value.to_set
        rescue
          strict ? raise_conversion_type(value) : value
        end
      end
    end

    def self.load(conversions)
      conversions.register NullConverter.new(:array, :array)
      conversions.register StringToArrayConverter.new(:string, :array)
      conversions.register StringToBoolArrayConverter.new(:string, :bools)
      conversions.register StringToBoolArrayConverter.new(:string, :booleans)
      conversions.register StringToIntegerArrayConverter.new(:string, :integers)
      conversions.register StringToIntegerArrayConverter.new(:string, :ints)
      conversions.register ArrayToNumericConverter.new(:array, :numeric)
      conversions.register ArrayToBooleanConverter.new(:array, :booleans)
      conversions.register ArrayToBooleanConverter.new(:array, :bools)
      conversions.register ObjectToArrayConverter.new(:object, :array)
      conversions.register ObjectToArrayConverter.new(:hash, :array)
    end
  end # ArrayConverters
end # Necromancer
