# frozen_string_literal: true

require "set"

require_relative "../converter"
require_relative "boolean"
require_relative "numeric"

module Necromancer
  # Container for Array converter classes
  module ArrayConverters
    ARRAY_MATCHER = /^(.+?(\s*(?<sep>(,|-))\s*))+/x.freeze

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

        if match = value.to_s.match(ARRAY_MATCHER)
          value.to_s.split(match[:sep])
        else
          strict ? raise_conversion_type(value) : Array(value)
        end
      end
    end

    class StringToBooleanArrayConverter < Converter
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
        bool_converter = ArrayToBooleanArrayConverter.new(:array, :boolean)
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

    class StringToFloatArrayConverter < Converter
      # @example
      #   converter.call("1,2,3") # => [1.0, 2.0, 3.0]
      #
      # @api public
      def call(string, strict: config.strict)
        array_converter = StringToArrayConverter.new(:string, :array)
        array = array_converter.(string, strict: strict)
        float_converter = ArrayToFloatArrayConverter.new(:array, :floats)
        float_converter.(array, strict: strict)
      end
    end

    class StringToNumericArrayConverter < Converter
      # Convert string value to array with numeric values
      #
      # @example
      #   converter.call("1,2.0,3") # => [1, 2.0, 3]
      #
      # @api public
      def call(string, strict: config.strict)
        array_converter = StringToArrayConverter.new(:string, :array)
        array = array_converter.(string, strict: strict)
        num_converter = ArrayToNumericArrayConverter.new(:array, :numeric)
        num_converter.(array, strict: strict)
      end
    end

    class ArrayToIntegerArrayConverter < Converter
      # @example
      #   converter.call(["1", "2", "3"]) # => [1, 2, 3]
      #
      # @api public
      def call(array, strict: config.strict)
        int_converter = NumericConverters::StringToIntegerConverter.new(:string,
                                                                        :integer)
        array.map { |val| int_converter.(val, strict: strict) }
      end
    end

    class ArrayToFloatArrayConverter < Converter
      # @example
      #   converter.call(["1", "2", "3"]) # => [1.0, 2.0, 3.0]
      #
      # @api public
      def call(array, strict: config.strict)
        float_converter = NumericConverters::StringToFloatConverter.new(:string,
                                                                        :float)
        array.map { |val| float_converter.(val, strict: strict) }
      end
    end

    # An object that converts an array to an array with numeric values
    class ArrayToNumericArrayConverter < Converter
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
        num_converter = NumericConverters::StringToNumericConverter.new(:string,
                                                                        :numeric)
        value.map { |val| num_converter.(val, strict: strict) }
      end
    end

    # An object that converts an array to an array with boolean values
    class ArrayToBooleanArrayConverter < Converter
      # @example
      #   converter.call(["t", "f", "yes", "no"]) # => [true, false, true, false]
      #
      # @param [Array] value
      #   the array value to boolean
      #
      # @api public
      def call(value, strict: config.strict)
        bool_converter = BooleanConverters::StringToBooleanConverter.new(:string,
                                                                         :boolean)
        value.map { |val| bool_converter.(val, strict: strict) }
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
        Array(value)
      rescue StandardError
        strict ? raise_conversion_type(value) : value
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
        value.to_set
      rescue StandardError
        strict ? raise_conversion_type(value) : value
      end
    end

    def self.load(conversions)
      [
        NullConverter.new(:array, :array),

        StringToArrayConverter.new(:string, :array),
        StringToBooleanArrayConverter.new(:string, :bools),
        StringToBooleanArrayConverter.new(:string, :booleans),
        StringToIntegerArrayConverter.new(:string, :integers),
        StringToIntegerArrayConverter.new(:string, :ints),
        StringToFloatArrayConverter.new(:string, :floats),
        StringToNumericArrayConverter.new(:string, :numerics),
        StringToNumericArrayConverter.new(:string, :nums),

        ArrayToNumericArrayConverter.new(:array, :numerics),
        ArrayToNumericArrayConverter.new(:array, :nums),
        ArrayToIntegerArrayConverter.new(:array, :integers),
        ArrayToIntegerArrayConverter.new(:array, :ints),
        ArrayToFloatArrayConverter.new(:array, :floats),
        ArrayToBooleanArrayConverter.new(:array, :booleans),
        ArrayToBooleanArrayConverter.new(:array, :bools),

        ObjectToArrayConverter.new(:object, :array),
        ObjectToArrayConverter.new(:hash, :array)
      ].each do |converter|
        conversions.register converter
      end
    end
  end # ArrayConverters
end # Necromancer
