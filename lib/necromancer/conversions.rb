# coding: utf-8

module Necromancer
  # Represents the context used to configure various converters
  # and facilitate type conversion
  #
  # @api public
  class Conversions
    DELIMITER = '->'.freeze

    # TODO: allow to register converters as just simple proc objects
    #
    # register "integer->string", { |value| value.to_s }
    # if block present then take it as converter class
    #

    # Creates a new conversions map
    #
    # @example
    #   conversion = Necromancer::Conversions.new
    #
    # @api public
    def initialize
      @converter_map = {}
    end

    # Load converters
    #
    # @api private
    def load
      ArrayConverters.load(self)
      BooleanConverters.load(self)
      DateTimeConverters.load(self)
      FloatConverters.load(self)
      IntegerConverters.load(self)
      RangeConverters.load(self)
    end

    def [](source, target)
      key = "#{source}#{DELIMITER}#{target}"
      converter_map[key] || fail(NoTypeConversionAvailableError)
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
      return false if converter_map.key?(key)
      converter_map[key] = converter
      true
    end

    def to_hash
      converter_map.dup
    end

    protected

    def generate_key(converter)
      parts = []
      parts << (converter.source ? converter.source.to_s : 'none')
      parts << (converter.target ? converter.target.to_s : 'none')
      parts.join(DELIMITER)
    end

    # Map of type and conversion
    #
    # @api private
    attr_reader :converter_map
  end # Conversions
end # Necromancer
