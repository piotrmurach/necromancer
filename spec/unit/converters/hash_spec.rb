# frozen_string_literal: true

RSpec.describe Necromancer::HashConverters, "#call" do
  describe ":string -> :hash" do
    subject(:converter) { Necromancer::HashConverters::StringToHashConverter.new }

    {
      "a=1" => {a: "1"},
      "a=1&b=2" => {a: "1", b: "2"},
      "a= & b=2" => {a: "", b: "2"},
      "a=1 & b=2 & a=3" => {a: ["1", "3"], b: "2"},
      "a:1 b:2" => {a: "1", b: "2"},
      "a:1 b:2 a:3" => {a: ["1", "3"], b: "2"},
    }.each do |input, obj|
      it "converts #{input.inspect} to #{obj.inspect}" do
        expect(converter.(input)).to eq(obj)
      end
    end
  end
end
