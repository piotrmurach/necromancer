# frozen_string_literal: true

require_relative "../converter"
require_relative "../null_converter"

module Necromancer
  # Container for Numeric converter classes
  module NumericConverters
    INTEGER_MATCHER = /^\s*[-+]?\s*(\d[\d\s]*)?$/.freeze

    FLOAT_MATCHER = /^\s*[-+]?([\d\s]*)(\.[\d\s]+)?([eE]?[-+]?[\d\s]+)?$/.freeze

    # An object that converts a String to an Integer
    class StringToIntegerConverter < Converter
      # Convert string value to integer
      #
      # @example
      #   converter.call("1abc")  # => 1
      #
      # @api public
      def call(value, strict: config.strict)
        Integer(value)
      rescue StandardError
        strict ? raise_conversion_type(value) : value.to_i
      end
    end

    # An object that converts an Integer to a String
    class IntegerToStringConverter < Converter
      # Convert integer value to string
      #
      # @example
      #   converter.call(1)  # => "1"
      #
      # @api public
      def call(value, **_)
        value.to_s
      end
    end

    # An object that converts a String to a Float
    class StringToFloatConverter < Converter
      # Convert string to float value
      #
      # @example
      #   converter.call("1.2") # => 1.2
      #
      # @api public
      def call(value, strict: config.strict)
        Float(value)
      rescue StandardError
        strict ? raise_conversion_type(value) : value.to_f
      end
    end

    # An object that converts a String to a Numeric
    class StringToNumericConverter < Converter
      # Convert string to numeric value
      #
      # @example
      #   converter.call("1.0")  # => 1.0
      #
      # @example
      #   converter.call("1")   # => 1
      #
      # @api public
      def call(value, strict: config.strict)
        case value
        when INTEGER_MATCHER
          StringToIntegerConverter.new(:string, :integer).(value, strict: strict)
        when FLOAT_MATCHER
          StringToFloatConverter.new(:string, :float).(value, strict: strict)
        else
          strict ? raise_conversion_type(value) : value
        end
      end
    end

    def self.load(conversions)
      [
        StringToIntegerConverter.new(:string, :integer),
        IntegerToStringConverter.new(:integer, :string),
        NullConverter.new(:integer, :integer),
        StringToFloatConverter.new(:string, :float),
        NullConverter.new(:float, :float),
        StringToNumericConverter.new(:string, :numeric)
      ].each do |converter|
        conversions.register converter
      end
    end
  end # Conversion
end # Necromancer
