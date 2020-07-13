# frozen_string_literal: true

RSpec.describe Necromancer::RangeConverters, "#call" do
  describe ":string -> :range" do
    subject(:converter) { described_class::StringToRangeConverter.new }

    {
      "" => "",
      "a" => "a",
      "1" => 1..1,
      "1.0" => 1.0..1.0,
      "1..10" => 1..10,
      "1.0..10.0" => 1.0..10.0,
      "1-10"  => 1..10,
      "1 , 10"  => 1..10,
      "1...10" => 1...10,
      "1 . . 10" => 1..10,
      "-1..10" => -1..10,
      "1..-10" => 1..-10,
      "a..z" => "a".."z",
      "a . . . z" => "a"..."z",
      "a-z" => "a".."z",
      "A , Z" => "A".."Z"
    }.each do |actual, expected|
      it "converts #{actual.inspect} to range type" do
        expect(converter.call(actual)).to eql(expected)
      end
    end

    it "raises error for empty string in strict mode" do
      expect {
        converter.call("", strict: true)
      }.to raise_error(Necromancer::ConversionTypeError)
    end
  end
end
