# coding: utf-8

require 'spec_helper'

RSpec.describe Necromancer::ArrayConverters::ObjectToArrayConverter, '.call' do
  subject(:converter) { described_class.new(:object, :array) }

  it "converts nil to array" do
    expect(converter.call(nil)).to eq([])
  end

  it "converts custom object to array" do
    Custom = Class.new do
      def to_ary
        [:x, :y]
      end
    end
    custom = Custom.new
    expect(converter.call(custom)).to eq([:x, :y])
  end

  it "fails to convert" do
    Custom = Class.new do
      def to_ary
        raise
      end
    end
    custom = Custom.new
    expect {
      converter.call(custom, strict: true)
    }.to raise_error
  end
end
