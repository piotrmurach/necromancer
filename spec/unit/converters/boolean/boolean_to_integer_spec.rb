# coding: utf-8

require 'spec_helper'

RSpec.describe Necromancer::BooleanConverters::BooleanToIntegerConverter, '.call' do

  subject(:converter) { described_class.new }

  it "converts true to 1 value" do
    expect(converter.call(true)).to eq(1)
  end

  it "converts false to 0 value" do
    expect(converter.call(false)).to eq(0)
  end
end
