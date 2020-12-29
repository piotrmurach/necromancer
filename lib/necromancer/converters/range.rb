# frozen_string_literal: true

require_relative "../converter"
require_relative "../null_converter"

module Necromancer
  # Container for Range converter classes
  module RangeConverters
    SINGLE_DIGIT_MATCHER = /^(?<digit>-?\d+(\.\d+)?)$/.freeze

    DIGIT_MATCHER = /^(?<open>-?\d+(\.\d+)?)
                      \s*(?<sep>(\.\s*){2,3}|-|,)\s*
                      (?<close>-?\d+(\.\d+)?)$
                    /x.freeze

    LETTER_MATCHER = /^(?<open>\w)
                      \s*(?<sep>(\.\s*){2,3}|-|,)\s*
                      (?<close>\w)$
                      /x.freeze

    # An object that converts a String to a Range
    class StringToRangeConverter < Converter
      # Convert value to Range type with possible ranges
      #
      # @param [Object] value
      #
      # @example
      #   converter.call("0,9")  # => (0..9)
      #
      # @example
      #   converter.call("0-9")  # => (0..9)
      #
      # @api public
      def call(value, strict: config.strict)
        if match = value.match(SINGLE_DIGIT_MATCHER)
          digit = cast_to_num(match[:digit])
          ::Range.new(digit, digit)
        elsif match = value.match(DIGIT_MATCHER)
          open = cast_to_num(match[:open])
          close = cast_to_num(match[:close])
          ::Range.new(open, close, match[:sep].gsub(/\s*/, "") == "...")
        elsif match = value.match(LETTER_MATCHER)
          ::Range.new(match[:open], match[:close],
                      match[:sep].gsub(/\s*/, "") == "...")
        else
          strict ? raise_conversion_type(value) : value
        end
      end

      # Convert range end to numeric value
      #
      # @api private
      def cast_to_num(str)
        Integer(str)
      rescue ArgumentError
        Float(str)
      rescue ArgumentError
        nil
      end
    end

    def self.load(conversions)
      [
        StringToRangeConverter.new(:string, :range),
        NullConverter.new(:range, :range)
      ].each do |converter|
        conversions.register converter
      end
    end
  end # RangeConverters
end # Necromancer
