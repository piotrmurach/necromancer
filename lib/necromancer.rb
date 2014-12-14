# coding: utf-8

require 'forwardable'
require 'date'
require 'set'

require 'necromancer/conversions'
require 'necromancer/configuration'
require 'necromancer/context'
require 'necromancer/converter'
require 'necromancer/null_converter'
require 'necromancer/converters/array'
require 'necromancer/converters/boolean'
require 'necromancer/converters/date_time'
require 'necromancer/converters/numeric'
require 'necromancer/converters/range'
require 'necromancer/conversion_target'
require 'necromancer/version'

module Necromancer
  # Raised when cannot conver to a given type
  ConversionTypeError = Class.new(StandardError)

  # Raised when conversion type is not available
  NoTypeConversionAvailableError = Class.new(StandardError)

  # Create a conversion instance
  #
  # @example
  #   converter = Necromancer.new
  #
  # @return [Context]
  #
  # @api private
  def new(&block)
    Context.new(&block)
  end

  module_function :new
end # Necromancer
