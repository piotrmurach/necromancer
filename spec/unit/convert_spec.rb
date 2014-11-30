# coding: utf-8

require 'spec_helper'

RSpec.describe Necromancer, '.convert' do

  subject(:converter) { described_class.new }

  context 'when integer' do
    it "converts string to integer" do
      expect(converter.convert('1').to(:integer)).to eq(1)
    end

    it "allows for block for conversion method" do
      expect(converter.convert { '1' }.to(:integer)).to eq(1)
    end

    it "convers integer to string" do
      expect(converter.convert(1).to(:string)).to eq('1')
    end

    it "allows for null type conversion" do
      expect(converter.convert(1).to(:integer)).to eq(1)
    end

    it "raises error when in strict mode" do
      expect {
        converter.convert('1a').to(:integer, strict: true)
      }.to raise_error(Necromancer::ConversionTypeError)
    end
  end

  context 'when boolean' do
    it "converts boolean to boolean" do
      expect(converter.convert(true).to(:boolean)).to eq(true)
    end

    it "converts string to boolean" do
      expect(converter.convert('yes').to(:boolean)).to eq(true)
    end

    it "converts integer to boolean" do
      expect(converter.convert(0).to(:boolean)).to eq(false)
    end

    it "converts boolean to integer" do
      expect(converter.convert(true).to(:integer)).to eq(1)
    end
  end

  context 'when range' do
    it "converts string to range" do
      expect(converter.convert('1-10').to(:range)).to eq(1..10)
    end
  end

  context 'when array' do
    it "converts string to array" do
      expect(converter.convert("1,2,3").to(:array)).to eq([1,2,3])
    end

    it "converts array to numeric " do
      expect(converter.convert(['1','2.3','3.0']).to(:numeric)).to eq([1,2.3,3.0])
    end
  end
end
