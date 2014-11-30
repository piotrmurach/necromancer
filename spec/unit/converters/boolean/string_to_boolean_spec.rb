# coding: utf-8

require 'spec_helper'

RSpec.describe Necromancer::BooleanConverters::StringToBooleanConverter, '.call' do

  subject(:converter) { described_class.new }

  it "raises error for empty string" do
    expect { converter.call('') }.to raise_error(ArgumentError)
  end

  it "passes through boolean value" do
    expect(converter.call(true)).to eq(true)
  end

  it "converts 'true' to true value" do
    expect(converter.call('true')).to eq(true)
  end

  it "converts 'TRUE' to true value" do
    expect(converter.call('TRUE')).to eq(true)
  end

  it "converts TRUE to true value" do
    expect(converter.call(TRUE)).to eq(true)
  end

  it "converts 't' to true value" do
    expect(converter.call('t')).to eq(true)
  end

  it "converts 'T' to true value" do
    expect(converter.call('T')).to eq(true)
  end

  it "converts 1 to true value" do
    expect(converter.call(1)).to eq(true)
  end

  it "converts '1' to true value" do
    expect(converter.call('1')).to eq(true)
  end

  it "converts 'y' to true value" do
    expect(converter.call('y')).to eq(true)
  end

  it "converts 'yes' to true value" do
    expect(converter.call('yes')).to eq(true)
  end

  it "converts 'on' to true value" do
    expect(converter.call('on')).to eq(true)
  end

  it "converts 'false' to false value" do
    expect(converter.call('false')).to eq(false)
  end

  it "converts FALSE to false value" do
    expect(converter.call(FALSE)).to eq(false)
  end

  it "converts 'FALSE' to false value" do
    expect(converter.call('FALSE')).to eq(false)
  end

  it "converts 'f' to false value" do
    expect(converter.call('f')).to eq(false)
  end

  it "converts 'F' to false value" do
    expect(converter.call('F')).to eq(false)
  end

  it "converts '0' to false value" do
    expect(converter.call('0')).to eq(false)
  end

  it "converts 'n' to false value" do
    expect(converter.call('n')).to eq(false)
  end

  it "converts 'no' to false value" do
    expect(converter.call('no')).to eq(false)
  end

  it "converts 'off' to false value" do
    expect(converter.call('off')).to eq(false)
  end

  it "fails to convert unkonwn value FOO" do
    expect { converter.call('FOO') }.to raise_error(ArgumentError)
  end
end
