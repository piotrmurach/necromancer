# frozen_string_literal: true

RSpec.describe Necromancer::ArrayConverters, "#call" do
  describe ":string -> :booleans" do
    subject(:converter) { described_class::StringToBoolArrayConverter.new }

    {
      "t,f,t" => [true, false, true],
      "yes,no,Y" => [true, false, true]
    }.each do |input, obj|
      it "converts #{input.inspect} to #{obj.inspect}" do
        expect(converter.(input)).to eq(obj)
      end
    end

    it "fails to convert in strict mode" do
      expect {
        converter.("yes,unknown", strict: true)
      }.to raise_error(Necromancer::ConversionTypeError,
                      "'unknown' could not be converted from `string` into `boolean`")
    end
  end

  describe ":string -> :integers/:ints" do
    subject(:converter) { described_class::StringToIntegerArrayConverter.new }

    {
      "1,2,3" => [1, 2, 3],
      "1.2, 2.3, 3.4" => [1, 2, 3]
    }.each do |input, obj|
      it "converts #{input.inspect} to #{obj.inspect}" do
        expect(converter.(input)).to eq(obj)
      end
    end

    it "fails to convert in strict mode" do
      expect {
        converter.("1,unknown", strict: true)
      }.to raise_error(Necromancer::ConversionTypeError,
                      "'unknown' could not be converted from `string` into `integer`")
    end
  end

  describe ":array -> :integers" do
    subject(:converter) { described_class::ArrayToIntegerArrayConverter.new }

    {
      %w[1 2 3] => [1, 2, 3],
      %w[1.2 2.3 3.4] => [1, 2, 3]
    }.each do |input, obj|
      it "converts #{input.inspect} to #{obj.inspect}" do
        expect(converter.(input)).to eq(obj)
      end
    end
  end
end
