# frozen_string_literal: true

require_relative "converter"

module Necromancer
  # A pass through converter
  class NullConverter < Converter
    def call(value, strict: config.strict)
      value
    end
  end # NullConverter
end # Necromancer
