# frozen_string_literal: true

module Necromancer
  module HashConverters
    # An object that converts a String to a Hash
    class StringToHashConverter < Converter
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
      def call(value, string: config.strict)
        values = value.split(/\s*[& ]\s*/)
        values.each_with_object({}) do |pair, pairs|
          key, value = pair.split(/[=:]/, 2)
          if (current = pairs[key.to_sym])
            pairs[key.to_sym] = Array(current) << value
          else
            pairs[key.to_sym] = value
          end
          pairs
        end
      end
    end

    def self.load(conversions)
      conversions.register NullConverter.new(:hash, :hash)
      conversions.register StringToHashConverter.new(:string, :hash)
    end
  end # HashConverters
end # Necromancer
