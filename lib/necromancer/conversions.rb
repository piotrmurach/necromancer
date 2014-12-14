# coding: utf-8

module Necromancer
  # Represents the context used to configure various converters
  # and facilitate type conversion
  #
  # @api public
  class Conversions
    DELIMITER = '->'.freeze

    # Creates a new conversions map
    #
    # @example
    #   conversion = Necromancer::Conversions.new
    #
    # @api public
    def initialize(configuration = Configuration.new)
      @configuration = configuration
      @converter_map = {}
    end

    # Load converters
    #
    # @api private
    def load
      ArrayConverters.load(self)
      BooleanConverters.load(self)
      DateTimeConverters.load(self)
      NumericConverters.load(self)
      RangeConverters.load(self)
    end

    # Retrieve converter for source and target
    #
    # @param [Object] source
    #   the source of conversion
    #
    # @param [Object] target
    #   the target of conversion
    #
    # @return [Converter]
    #  the converter for the source and target
    #
    # @api public
    def [](source, target)
      key = "#{source}#{DELIMITER}#{target}"
      converter_map[key] ||
      converter_map["object->#{target}"] ||
      fail_no_type_conversion_available(key)
    end

    # Fail with conversion error
    #
    # @api private
    def fail_no_type_conversion_available(key)
      fail NoTypeConversionAvailableError, "Conversion '#{key}' unavailable."
    end

    # @example with simple object
    #
    #
    # @example with block
    #
    #
    # @api public
    def register(converter = nil, &block)
      converter ||= Converter.create(&block)
      key = generate_key(converter)
      converter = add_config(converter, @configuration)
      return false if converter_map.key?(key)
      converter_map[key] = converter
      true
    end

    def to_hash
      converter_map.dup
    end

    protected

    # @api private
    def generate_key(converter)
      parts = []
      parts << (converter.source ? converter.source.to_s : 'none')
      parts << (converter.target ? converter.target.to_s : 'none')
      parts.join(DELIMITER)
    end

    # Inject config into converter
    #
    # @api private
    def add_config(converter, config)
      converter.instance_exec(:"@config") do |var|
        instance_variable_set(var, config)
      end
      converter
    end

    # Map of type and conversion
    #
    # @return [Hash]
    #
    # @api private
    attr_reader :converter_map
  end # Conversions
end # Necromancer
