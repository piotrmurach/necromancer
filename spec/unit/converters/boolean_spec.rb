# frozen_string_literal: true

RSpec.describe Necromancer::BooleanConverters, "#call"  do
  describe ":string -> :integer" do
    subject(:converter) { described_class::StringToBooleanConverter.new(:string, :boolean) }

    it "passes through boolean value" do
      expect(converter.call(true)).to eq(true)
    end

    %w[true TRUE t T 1 y Y YES yes on ON].each do |value|
      it "converts '#{value}' to true value" do
        expect(converter.call(value)).to eq(true)
      end
    end

    %w[false FALSE f F 0 n N NO No no off OFF].each do |value|
      it "converts '#{value}' to false value" do
        expect(converter.call(value)).to eq(false)
      end
    end

    it "raises error for empty string strict mode" do
      expect {
        converter.call("", strict: true)
      }.to raise_error(Necromancer::ConversionTypeError)
    end

    it "fails to convert unkonwn value FOO" do
      expect {
        converter.call("FOO", strict: true)
      }.to raise_error(Necromancer::ConversionTypeError)
    end

  end

  describe ":boolean -> :integer" do
    subject(:converter) { described_class::BooleanToIntegerConverter.new(:boolean, :integer) }

    {
      true => 1,
      false => 0,
      "unknown" => "unknown"
    }.each do |input, obj|
      it "converts #{input.inspect} to #{obj.inspect}" do
        expect(converter.(input)).to eq(obj)
      end
    end

    it "fails to convert in strict mode" do
      expect {
        converter.call("unknown", strict: true)
      }.to raise_error(Necromancer::ConversionTypeError,
                      "'unknown' could not be converted from `boolean` into `integer`")
    end
  end

  describe ":integer -> :boolean" do
    subject(:converter) { described_class::IntegerToBooleanConverter.new }

    {
      1 => true,
      0 => false,
      "unknown" => "unknown"
    }.each do |input, obj|
      it "converts #{input.inspect} to #{obj.inspect}" do
        expect(converter.(input)).to eq(obj)
      end
    end

    it "fails to convert in strict mode" do
      expect  {
        converter.call("1", strict: true)
      }.to raise_error(Necromancer::ConversionTypeError)
    end
  end
end
