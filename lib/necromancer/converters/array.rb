# coding: utf-8

module Necromancer
  module ArrayConverters
    class StringToArrayConverter < Converter

      # @example
      #   converter.call('1,2,3')  # => ['1', '2', '3']
      #
      # @api public
      def call(value, options = {})
        case value.to_s
        when /^((\d+)(\s*(,)\s*)?)+$/
          value.to_s.split($4).map(&:to_i)
        when /^((\w)(\s*,\s*)?)+$/
          value.to_s.split(',')
        else
          fail ConversionTypeError, "#{value} could not be converted " \
                                    "from #{source} into `#{target}`"
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
