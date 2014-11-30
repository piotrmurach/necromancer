# coding: utf-8

require 'spec_helper'

RSpec.describe Necromancer::ArrayConverters::StringToArrayConverter, '.call' do
  subject(:converter) { described_class.new }

  it "converts `1,2,3` to array" do
    expect(converter.call('1,2,3')).to eq([1,2,3])
  end

  it "converts `a,b,c` to array" do
    expect(converter.call('a,b,c')).to eq(['a','b','c'])
  end
end
