# coding: utf-8

module Necromancer
  # Container for Date converter classes
  module DateTimeConverters
    # An object that converts a String to a Date
    class StringToDateConverter < Converter
      def call(value, options = {})
        strict = options.fetch(:strict, config.strict)
        Date.parse(value)
      rescue
        strict ? fail_conversion_type(value) : value
      end
    end

    # An object that converts a String to a DateTime
    class StringToDateTimeConverter < Converter
      def call(value, options = {})
        strict = options.fetch(:strict, config.strict)
        DateTime.parse(value)
      rescue
        strict ? fail_conversion_type(value) : value
      end
    end

    def self.load(conversions)
      conversions.register StringToDateConverter.new(:string, :date)
      conversions.register NullConverter.new(:date, :date)
      conversions.register StringToDateTimeConverter.new(:string, :datetime)
      conversions.register NullConverter.new(:datetime, :datetime)
    end
  end # DateTimeConverters
end # Necromancer
