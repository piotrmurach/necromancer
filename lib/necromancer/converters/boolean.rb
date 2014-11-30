# coding: utf-8

module Necromancer
  module BooleanConverters
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
      #    0, f, F, FALSE, false, False, n, N, NO,  no,  No, on, ON
      #
      # @api public
      def call(value, options = {})
        case value.to_s
        when /^(yes|y|on|t(rue)?|1)$/i
          return true
        when /^(no|n|off|f(alse)?|0)$/i
          return false
        else
          fail ArgumentError, "Expected boolean type, got #{value}"
        end
      end
    end

    # An object that converts an Integer to a Boolean
    class IntegerToBooleanConverter < Converter
      def call(value, options = {})
        !value.zero?
      end
    end

    # An object that converts a Boolean to an Integer
    class BooleanToIntegerConverter < Converter
      def call(value, options = {})
        value ? 1 : 0
      end
    end

    def self.load(conversions)
      conversions.register StringToBooleanConverter.new(:string, :boolean)
      conversions.register IntegerToBooleanConverter.new(:integer, :boolean)
      conversions.register BooleanToIntegerConverter.new(:boolean, :integer)
      conversions.register NullConverter.new(:boolean, :boolean)
    end
  end # BooleanConverters
end # Necromancer
