# encoding: utf-8

require_relative 'necromancer/context'
require_relative 'necromancer/version'

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
