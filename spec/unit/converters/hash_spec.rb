# frozen_string_literal: true

RSpec.describe Necromancer::HashConverters, "#call" do
  describe ":string -> :hash" do
    subject(:converter) { described_class::StringToHashConverter.new }

    {
      "a=1"             => { a: "1" },
      "a=1&b=2"         => { a: "1", b: "2" },
      "a= & b=2"        => { a: "", b: "2" },
      "a=1 & b=2 & a=3" => { a: %w[1 3], b: "2" },
      "a:1 b:2"         => { a: "1", b: "2" },
      "a:1 b:2 a:3"     => { a: %w[1 3], b: "2" }
    }.each do |input, obj|
      it "converts #{input.inspect} to #{obj.inspect}" do
        expect(converter.(input)).to eq(obj)
      end
    end
  end

  describe ":string -> :int_hash" do
    subject(:converter) { described_class::StringToIntegerHashConverter.new }

    {
      "a=1 & b=2 & a=3" => { a: [1, 3], b: 2 },
      "a:1 b:2 c:3"     => { a: 1, b: 2, c: 3 },
    }.each do |input, obj|
      it "converts #{input.inspect} to #{obj.inspect}" do
        expect(converter.(input)).to eq(obj)
      end
    end

    it "fails to convert '1.2o' value in strict mode" do
      expect {
        converter.("a=1.2o", strict: true)
      }.to raise_error(
        Necromancer::ConversionTypeError,
        "'1.2o' could not be converted from `string` into `integer`"
      )
    end
  end

  describe ":string -> :float_hash" do
    subject(:converter) { described_class::StringToFloatHashConverter.new }

    {
      "a=1 & b=2 & a=3" => { a: [1.0, 3.0], b: 2.0 },
      "a:1 b:2 c:3"     => { a: 1.0, b: 2.0, c: 3.0 }
    }.each do |input, obj|
      it "converts #{input.inspect} to #{obj.inspect}" do
        expect(converter.(input)).to eql(obj)
      end
    end

    it "fails to convert '1.2o' value in strict mode" do
      expect {
        converter.("a=1.2o", strict: true)
      }.to raise_error(
        Necromancer::ConversionTypeError,
        "'1.2o' could not be converted from `string` into `float`"
      )
    end
  end

  describe ":string -> :numeric_hash" do
    subject(:converter) { described_class::StringToNumericHashConverter.new }

    {
      "a=1 & b=2.0 & a=3.0" => { a: [1, 3.0], b: 2.0 },
      "a:1 b:2.0 c:3.0"     => { a: 1, b: 2.0, c: 3.0 }
    }.each do |input, obj|
      it "converts #{input.inspect} to #{obj.inspect}" do
        expect(converter.(input)).to eql(obj)
      end
    end

    it "fails to convert '1.2o' value in strict mode" do
      expect {
        converter.("a=1.2o", strict: true)
      }.to raise_error(
        Necromancer::ConversionTypeError,
        "'1.2o' could not be converted from `string` into `numeric`"
      )
    end
  end

  describe ":string -> :bool_hash" do
    subject(:converter) { described_class::StringToBooleanHashConverter.new }

    {
      "a=t & b=t & a=f" => { a: [true, false], b: true },
      "a:yes b:no c:t"  => { a: true, b: false, c: true }
    }.each do |input, obj|
      it "converts #{input.inspect} to #{obj.inspect}" do
        expect(converter.(input)).to eql(obj)
      end
    end

    it "fails to convert '1.2o' value in strict mode" do
      expect {
        converter.("a=1.2", strict: true)
      }.to raise_error(
        Necromancer::ConversionTypeError,
        "'1.2' could not be converted from `string` into `boolean`"
      )
    end
  end
end
