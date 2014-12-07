# coding: utf-8

require 'spec_helper'

RSpec.describe Necromancer::IntegerConverters::StringToIntegerConverter, '.call' do

  subject(:converter) { described_class.new(:string, :integer) }

  it "raises error for empty string in strict mode" do
    expect {
      converter.call('', strict: true)
    }.to raise_error(Necromancer::ConversionTypeError)
  end

  it "converts empty string to 0 in non-strict mode" do
    expect(converter.call('', strict: false)).to eq(0)
  end

  it "raises error for float in strict mode" do
    expect {
      converter.call(1.2, strict: true)
    }.to raise_error(Necromancer::ConversionTypeError)
  end

  it "converts float to integer in non-strict mode" do
    expect(converter.call(1.2)).to eq(1)
  end

  it "converts mixed string to integer in non-strict mode" do
    expect(converter.call('1abc')).to eq(1)
  end

  it "raises error for mixed string in strict mode" do
    expect {
      converter.call('1abc', strict: true)
    }.to raise_error(Necromancer::ConversionTypeError)
  end
end
