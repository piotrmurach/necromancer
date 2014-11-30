# coding: utf-8

require 'spec_helper'

RSpec.describe Necromancer::RangeConverters::StringToRangeConverter, '.call' do

  subject(:converter) { described_class.new }

  it "raises error for empty string" do
    expect { converter.call('') }.to raise_error(Necromancer::ConversionTypeError)
  end

  it "converts '1' to range" do
    expect(converter.call('1')).to eq(1..1)
  end

  it "converts '1..10' to range value" do
    expect(converter.call('1..10')).to eq(1..10)
  end

  it "converts '1-10' to range value" do
    expect(converter.call('1-10')).to eq(1..10)
  end

  it "converts '1,10' to range value" do
    expect(converter.call('1,10')).to eq(1..10)
  end

  it "converts '1...10' to range value" do
    expect(converter.call('1...10')).to eq(1...10)
  end

  it "converts '-1..10' to range value" do
    expect(converter.call('-1..10')).to eq(-1..10)
  end

  it "converts '1..-10' to range value" do
    expect(converter.call('1..-10')).to eq(1..-10)
  end

  it "converts 'a..z' to range value" do
    expect(converter.call('a..z')).to eq('a'..'z')
  end

  it "converts 'a-z' to range value" do
    expect(converter.call('a-z')).to eq('a'..'z')
  end

  it "converts 'A-Z' to range value" do
    expect(converter.call('A-Z')).to eq('A'..'Z')
  end
end
