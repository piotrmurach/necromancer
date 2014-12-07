# coding: utf-8

module Necromancer
  module FloatConverters
    # An object that converts a String to a Float
    class StringToFloatConverter < Converter
      # Convert string to float value
      #
      # @example
      #   converter.call('1.2') # => 1.2
      #
      # @api public
      def call(value, options = {})
        strict = options.fetch(:strict, false)
        Float(value.to_s)
      rescue
        strict ? fail_conversion_type(value) : value.to_f
      end
    end

    def self.load(conversions)
      conversions.register StringToFloatConverter.new(:string, :float)
      conversions.register NullConverter.new(:float, :float)
    end
  end # Conversion
end # Necromancer
