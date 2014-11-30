# coding: utf-8

module Necromancer
  # A pass through converter
  class NullConverter < Converter
    def call(value, options = {})
      value
    end
  end # NullConverter
end # Necromancer
