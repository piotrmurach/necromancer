# coding: utf-8

module Necromancer
  # Container for Integer converter classes
  module IntegerConverters
    # An object that converts a String to an Integer
    class StringToIntegerConverter < Converter
      # Convert string value to integer
      #
      # @example
      #   converter.call('1abc')  # => 1
      #
      # @api public
      def call(value, options = {})
        strict = options.fetch(:strict, false)
        Integer(value.to_s)
      rescue
        strict ? fail_conversion_type(value) : value.to_i
      end
    end

    # An object that converts an Integer to a String
    class IntegerToStringConverter < Converter
      # Convert integer value to string
      #
      # @example
      #   converter.call(1)  # => '1'
      #
      # @api public
      def call(value, _)
        value.to_s
      end
    end

    def self.load(conversions)
      conversions.register StringToIntegerConverter.new(:string, :integer)
      conversions.register IntegerToStringConverter.new(:integer, :string)
      conversions.register NullConverter.new(:integer, :integer)
    end
  end # IntegerConverters
end # Necromancer
