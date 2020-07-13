# frozen_string_literal: true

RSpec.describe Necromancer::ArrayConverters::StringToArrayConverter, "#call" do
  subject(:converter) { described_class.new(:string, :array) }

  {
    "" => [],
    "123" => %w[123],
    "1,2,3" => %w[1 2 3],
    "1-2-3" => %w[1 2 3],
    " 1  - 2 - 3 " => [" 1  ", " 2 ", " 3 "],
    "1  ,  2  , 3" => ["1  ", "  2  ", " 3"],
    "1.2,2.3,3.4" => %w[1.2 2.3 3.4],
    "a,b,c" => %w[a b c],
    "a-b-c" => %w[a b c],
    "aa a,b bb,c c c" => %w[aa\ a b\ bb c\ c\ c],
  }.each do |input, obj|
    it "converts #{input.inspect} to #{obj.inspect}" do
      expect(converter.(input)).to eq(obj)
    end
  end

  it "fails to convert empty string to array in strict mode" do
    expect {
      converter.call("unknown", strict: true)
    }.to raise_error(Necromancer::ConversionTypeError,
                     "'unknown' could not be converted from `string` into `array`")
  end
end
