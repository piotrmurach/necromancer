# coding: utf-8

module Necromancer
  # Container for Range converter classes
  module RangeConverters
    # An object that converts a String to a Range
    class StringToRangeConverter < Converter
      # Convert value to Range type with possible ranges
      #
      # @param [Object] value
      #
      # @example
      #   converter.call('0,9')  # => (0..9)
      #
      # @example
      #   converter.call('0-9')  # => (0..9)
      #
      # @api public
      def call(value, options = {})
        case value.to_s
        when /\A(\-?\d+)\Z/
          ::Range.new($1.to_i, $1.to_i)
        when /\A(-?\d+?)(\.{2}\.?|-|,)(-?\d+)\Z/
          ::Range.new($1.to_i, $3.to_i, $2 == '...')
        when /\A(\w)(\.{2}\.?|-|,)(\w)\Z/
          ::Range.new($1.to_s, $3.to_s, $2 == '...')
        else
          fail ConversionTypeError, "#{value} could not be converted " \
                                    "from #{source} into Range type"
        end
      end
    end

    def self.load(conversions)
      conversions.register StringToRangeConverter.new(:string, :range)
    end
  end # RangeConverters
end # Necromancer
