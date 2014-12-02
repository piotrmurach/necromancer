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
            fail ConversionTypeError, "#{value} could not be converted " \
                                      "from #{source} into `#{target}`"
          else
            Array(value.to_s)
          end
        end
      end
    end

    class ArrayToNumericConverter < Converter
      def call(value, options = {})
        strict = options.fetch(:strict, false)
        value.reduce([]) do |acc, el|
          acc << case el.to_s
          when /^\d+\.\d+$/
            el.to_f
          when /^\d+$/
            el.to_i
          else
            if strict
              raise ConversionTypeError, "#{value} could not be converted " \
                                        " from `#{source}` into `#{target}`"
            else
              el
            end
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
