# coding: utf-8

require 'spec_helper'

RSpec.describe Necromancer::NumericConverters::StringToIntegerConverter, '.call' do

  subject(:converter) { described_class.new(:string, :integer) }

  {
    '1'   => 1,
    '+1'  => 1,
    '-1'  => -1,
    '1.2' => 1,
    '.1'  => 0
  }.each do |actual, expected|
    it "converts '#{actual}' to float value" do
      expect(converter.call(actual)).to eq(expected)
    end
  end

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
