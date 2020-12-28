# frozen_string_literal: true

require_relative "../converter"
require_relative "boolean"
require_relative "numeric"

module Necromancer
  module HashConverters
    # An object that converts a String to a Hash
    class StringToHashConverter < Converter
      DEFAULT_CONVERSION = ->(val, *_rest) { val }

      # Convert string value to hash
      #
      # @example
      #   converter.call("a:1 b:2 c:3")
      #   # => {a: "1", b: "2", c: "3"}
      #
      # @example
      #   converter.call("a=1 & b=3 & c=3")
      #   # => {a: "1", b: "2", c: "3"}
      #
      # @api public
      def call(value, strict: config.strict, value_converter: DEFAULT_CONVERSION)
        values = value.split(/\s*[& ]\s*/)
        values.each_with_object({}) do |pair, pairs|
          key, value = pair.split(/[=:]/, 2)
          value_converted = value_converter.(value, strict: strict)
          if current = pairs[key.to_sym]
            pairs[key.to_sym] = Array(current) << value_converted
          else
            pairs[key.to_sym] = value_converted
          end
          pairs
        end
      end
    end

    class StringToIntegerHashConverter < Converter
      # Convert string value to hash with integer values
      #
      # @example
      #   converter.call("a:1 b:2 c:3")
      #   # => {a: 1, b: 2, c: 3}
      #
      # @api public
      def call(value, strict: config.strict)
        int_converter = NumericConverters::StringToIntegerConverter.new(:string,
                                                                        :integer)
        hash_converter = StringToHashConverter.new(:string, :hash)
        hash_converter.(value, strict: strict, value_converter: int_converter)
      end
    end

    class StringToFloatHashConverter < Converter
      # Convert string value to hash with float values
      #
      # @example
      #   converter.call("a:1 b:2 c:3")
      #   # => {a: 1.0, b: 2.0, c: 3.0}
      #
      # @api public
      def call(value, strict: config.strict)
        float_converter = NumericConverters::StringToFloatConverter.new(:string,
                                                                        :float)
        hash_converter = StringToHashConverter.new(:string, :hash)
        hash_converter.(value, strict: strict, value_converter: float_converter)
      end
    end

    class StringToNumericHashConverter < Converter
      # Convert string value to hash with numeric values
      #
      # @example
      #   converter.call("a:1 b:2.0 c:3")
      #   # => {a: 1, b: 2.0, c: 3}
      #
      # @api public
      def call(value, strict: config.strict)
        num_converter = NumericConverters::StringToNumericConverter.new(:string,
                                                                        :numeric)
        hash_converter = StringToHashConverter.new(:string, :hash)
        hash_converter.(value, strict: strict, value_converter: num_converter)
      end
    end

    class StringToBooleanHashConverter < Converter
      # Convert string value to hash with boolean values
      #
      # @example
      #   converter.call("a:yes b:no c:t")
      #   # => {a: true, b: false, c: true}
      #
      # @api public
      def call(value, strict: config.strict)
        bool_converter = BooleanConverters::StringToBooleanConverter.new(:string,
                                                                         :boolean)
        hash_converter = StringToHashConverter.new(:string, :hash)
        hash_converter.(value, strict: strict, value_converter: bool_converter)
      end
    end

    def self.load(conversions)
      [
        NullConverter.new(:hash, :hash),
        StringToHashConverter.new(:string, :hash),
        StringToIntegerHashConverter.new(:string, :int_hash),
        StringToIntegerHashConverter.new(:string, :integer_hash),
        StringToFloatHashConverter.new(:string, :float_hash),
        StringToNumericHashConverter.new(:string, :num_hash),
        StringToNumericHashConverter.new(:string, :numeric_hash),
        StringToBooleanHashConverter.new(:string, :boolean_hash),
        StringToBooleanHashConverter.new(:string, :bool_hash)
      ].each do |converter|
        conversions.register(converter)
      end
    end
  end # HashConverters
end # Necromancer
