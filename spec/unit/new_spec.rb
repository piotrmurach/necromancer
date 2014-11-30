# coding: utf-8

require 'spec_helper'

RSpec.describe Necromancer, '#new' do

  subject(:converter) { described_class.new }

  it "creates context" do
    expect(converter).to be_a(Necromancer::Context)
  end
end
