# coding: utf-8

require 'spec_helper'

RSpec.describe Necromancer::DateTimeConverters::StringToDateConverter, '.call' do

  subject(:converter) { described_class.new(:string, :date) }

  it "converts '2014/12/07' to date value" do
    expect(converter.call('2014/12/07')).to eq(Date.parse('2014/12/07'))
  end

  it "converts '2014-12-07' to date value" do
    expect(converter.call('2014-12-07')).to eq(Date.parse('2014/12/07'))
  end

  it "fails to convert in strict mode" do
    expect {
      converter.call('2014 - 12 - 07', strict: true)
    }.to raise_error(Necromancer::ConversionTypeError)
  end
end
