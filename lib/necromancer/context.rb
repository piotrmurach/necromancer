# coding: utf-8

module Necromancer
  # A class used by Necromancer to provide user interace
  #
  # @api public
  class Context
    extend Forwardable

    def_delegators :"@conversions", :register

    # Create a context
    #
    # @api private
    def initialize
      @conversions = Conversions.new
      @conversions.load
    end

    # Converts the object
    # @param [Object] value
    #   any object to be converted
    #
    # @api public
    def convert(object = ConversionTarget::UndefinedValue, &block)
      ConversionTarget.for(conversions, object, block)
    end

    # Check if this converter can convert source to target
    #
    # @param [Object] source
    #   the source class
    # @param [Object] target
    #   the target class
    #
    # @return [Boolean]
    #
    # @api public
    def can?(source, target)
      !conversions[source, target].nil?
    rescue NoTypeConversionAvailableError
      false
    end

    protected

    attr_reader :conversions
  end # Context
end # Necromancer
