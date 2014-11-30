# coding: utf-8

require 'spec_helper'

RSpec.describe Necromancer::BooleanConverters::IntegerToBooleanConverter, '.call' do

  subject(:converter) { described_class.new }

  it "converts 1 to true value" do
    expect(converter.call(1)).to eq(true)
  end

  it "converts 0 to false value" do
    expect(converter.call(0)).to eq(false)
  end
end
