# coding: utf-8

require 'spec_helper'

RSpec.describe Necromancer::NumericConverters::StringToFloatConverter, '.call' do

  subject(:converter) { described_class.new(:string, :float) }

  it "raises error for empty string in strict mode" do
    expect {
      converter.call('', strict: true)
    }.to raise_error(Necromancer::ConversionTypeError)
  end

  {
    '1'   => 1.0,
    '+1'  => 1.0,
    '-1'  => -1.0,
    '1.2' => 1.2,
    '.1'  => 0.1
  }.each do |actual, expected|
    it "converts '#{actual}' to float value" do
      expect(converter.call(actual)).to eq(expected)
    end
  end

  it "failse to convert '1.2a' in strict mode" do
    expect {
      converter.call('1.2a', strict: true)
    }.to raise_error(Necromancer::ConversionTypeError)
  end

  it "converts '1.2a' in non-strict mode" do
    expect(converter.call('1.2a', strict: false)).to eq(1.2)
  end
end
