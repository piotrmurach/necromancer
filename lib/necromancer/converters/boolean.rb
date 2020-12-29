# frozen_string_literal: true

require_relative "../converter"
require_relative "../null_converter"

module Necromancer
  # Container for Boolean converter classes
  module BooleanConverters
    TRUE_MATCHER = /^(yes|y|on|t(rue)?|1)$/i.freeze

    FALSE_MATCHER = /^(no|n|off|f(alse)?|0)$/i.freeze

    # An object that converts a String to a Boolean
    class StringToBooleanConverter < Converter
      # Convert value to boolean type including range of strings
      #
      # @param [Object] value
      #
      # @example
      #   converter.call("True") # => true
      #
      #   other values converted to true are:
      #     1, t, T, TRUE,  true,  True,  y, Y, YES, yes, Yes, on, ON
      #
      # @example
      #   converter.call("False") # => false
      #
      #  other values coerced to false are:
      #    0, f, F, FALSE, false, False, n, N, NO,  no,  No, off, OFF
      #
      # @api public
      def call(value, strict: config.strict)
        case value.to_s
        when TRUE_MATCHER then true
        when FALSE_MATCHER then false
        else strict ? raise_conversion_type(value) : value
        end
      end
    end

    # An object that converts an Integer to a Boolean
    class IntegerToBooleanConverter < Converter
      # Convert integer to boolean
      #
      # @example
      #   converter.call(1)  # => true
      #
      # @example
      #   converter.call(0)  # => false
      #
      # @api public
      def call(value, strict: config.strict)
        !value.zero?
      rescue StandardError
        strict ? raise_conversion_type(value) : value
      end
    end

    # An object that converts a Boolean to an Integer
    class BooleanToIntegerConverter < Converter
      # Convert boolean to integer
      #
      # @example
      #   converter.call(true)   # => 1
      #
      # @example
      #   converter.call(false)  # => 0
      #
      # @api public
      def call(value, strict: config.strict)
        if %w[TrueClass FalseClass].include?(value.class.name)
          value ? 1 : 0
        else
          strict ? raise_conversion_type(value) : value
        end
      end
    end

    def self.load(conversions)
      [
        StringToBooleanConverter.new(:string, :boolean),
        IntegerToBooleanConverter.new(:integer, :boolean),
        BooleanToIntegerConverter.new(:boolean, :integer),
        NullConverter.new(:boolean, :boolean)
      ].each do |converter|
        conversions.register converter
      end
    end
  end # BooleanConverters
end # Necromancer
