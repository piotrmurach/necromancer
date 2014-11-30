# coding: utf-8

module Necromancer
  module FloatConverters
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
        if strict
          raise ConversionTypeError, "#{value} could not be converted from " \
                                     "`#{source}` into `#{target}`"
        else
          value.to_f
        end
      end
    end

    def self.load(conversions)
    end
  end # Conversion
end # Necromancer
