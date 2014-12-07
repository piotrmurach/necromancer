# coding: utf-8

require 'spec_helper'

RSpec.describe Necromancer::FloatConverters::StringToFloatConverter, '.call' do

  subject(:converter) { described_class.new(:string, :float) }

  it "raises error for empty string in strict mode" do
    expect {
      converter.call('', strict: true)
    }.to raise_error(Necromancer::ConversionTypeError)
  end

  it "converts '1' to float value" do
    expect(converter.call('1')).to eq(1.0)
  end

  it "converts '1.2a' to float value in non-strict mode" do
    expect(converter.call('1.2')).to eq(1.2)
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
