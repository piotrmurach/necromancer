# coding: utf-8

module Necromancer
  # Container for Array converter classes
  module ArrayConverters
    # An object that converts a String to an Array
    class StringToArrayConverter < Converter
      # Convert string value to array
      #
      # @example
      #   converter.call('a, b, c')  # => ['a', 'b', 'c']
      #
      # @example
      #   converter.call('1 - 2 - 3')  # => [1, 2, 3]
      #
      # @api public
      def call(value, options = {})
        strict = options.fetch(:strict, false)
        case value.to_s
        when /^\s*?((\d+)(\s*(,|-)\s*)?)+\s*?$/
          value.to_s.split($4).map(&:to_i)
        when /^((\w)(\s*(,|-)\s*)?)+$/
          value.to_s.split($4)
        else
          if strict
            fail_conversion_type(value)
          else
            Array(value)
          end
        end
      end
    end

    # An object that converts an Array to a numeric
    class ArrayToNumericConverter < Converter
      # Convert an array to a numeric value
      #
      # @example
      #   converter.call(['1', '2.3', '3.0])  # => [1, 2.3, 3.0]
      #
      # @param [Object] value
      #   the value to convert
      #
      # @api public
      def call(value, options = {})
        strict = options.fetch(:strict, false)
        value.reduce([]) do |acc, el|
          acc << case el.to_s
                 when /^\d+\.\d+$/ then el.to_f
                 when /^\d+$/ then el.to_i
                 else strict ?  fail_conversion_type(value) : el
                 end
        end
      end
    end

    def self.load(conversions)
      conversions.register StringToArrayConverter.new(:string, :array)
      conversions.register ArrayToNumericConverter.new(:array, :numeric)
    end
  end # ArrayConverters
end # Necromancer
