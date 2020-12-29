# frozen_string_literal: true

RSpec.describe Necromancer::NumericConverters, "#call" do
  describe ":string -> :float" do
    subject(:converter) {
      described_class::StringToFloatConverter.new(:string, :float)
    }

    {
      ""        => 0.0,
      "1"       => 1.0,
      "+1"      => 1.0,
      "1.2a"    => 1.2,
      "-1"      => -1.0,
      "1e1"     => 10.0,
      "1e-1"    => 0.1,
      "-1e1"    => -10.0,
      "-1e-1"   => -0.1,
      "1.0"     => 1.0,
      "1.0e+1"  => 10.0,
      "1.0e-1"  => 0.1,
      "-1.0e+1" => -10.0,
      "-1.0e-1" => -0.1,
      ".1"      => 0.1,
      ".1e+1"   => 1.0,
      ".1e-1"   => 0.01,
      "-.1e+1"  => -1.0,
      "-.1e-1"  => -0.01,
      " 1. 10 " => 1.0,
      "    1.0" => 1.0,
      " .1    " => 0.1,
      "  -1.1 " => -1.1,
      " -1 . 1" => -1.0
    }.each do |actual, expected|
      it "converts '#{actual}' to float value" do
        expect(converter.(actual)).to eql(expected)
      end
    end

    it "raises error for empty string in strict mode" do
      expect {
        converter.("", strict: true)
      }.to raise_error(Necromancer::ConversionTypeError)
    end

    it "fails to convert '1.2a' in strict mode" do
      expect {
        converter.("1.2a", strict: true)
      }.to raise_error(
        Necromancer::ConversionTypeError,
        "'1.2a' could not be converted from `string` into `float`"
      )
    end
  end

  describe ":string -> :integer" do
    subject(:converter) {
      described_class::StringToIntegerConverter.new(:string, :integer)
    }

    {
      ""        => 0,
      "1"       => 1,
      "1ab"     => 1,
      "+1"      => 1,
      "-1"      => -1,
      "1e+1"    => 1,
      "+1e-1"   => 1,
      "-1e1"    => -1,
      "-1e-1"   => -1,
      "1.0"     => 1,
      "1.0e+1"  => 1,
      "1.0e-1"  => 1,
      "-1.0e+1" => -1,
      "-1.0e-1" => -1,
      ".1"      => 0,
      ".1e+1"   => 0,
      ".1e-1"   => 0,
      "-.1e+1"  => 0,
      "-.1e-1"  => 0,
      " 1 00"   => 1,
      "  1  "   => 1,
      "  -1 "   => -1
    }.each do |actual, expected|
      it "converts '#{actual}' to float value" do
        expect(converter.(actual)).to eql(expected)
      end
    end

    it "raises error for empty string in strict mode" do
      expect {
        converter.("", strict: true)
      }.to raise_error(Necromancer::ConversionTypeError)
    end

    it "raises error for float in strict mode" do
      expect {
        converter.("1.2", strict: true)
      }.to raise_error(Necromancer::ConversionTypeError)
    end

    it "raises error for mixed string in strict mode" do
      expect {
        converter.("1abc", strict: true)
      }.to raise_error(Necromancer::ConversionTypeError)
    end
  end

  describe ":string -> :numeric" do
    subject(:converter) {
      described_class::StringToNumericConverter.new(:string, :numeric)
    }

    {
      ""        => 0,
      "1"       => 1,
      "+1"      => 1,
      "-1"      => -1,
      "1e1"     => 10.0,
      "1e-1"    => 0.1,
      "-1e1"    => -10.0,
      "-1e-1"   => -0.1,
      "1.0"     => 1.0,
      "1.0e+1"  => 10.0,
      "1.0e-1"  => 0.1,
      "-1.0e+1" => -10.0,
      "-1.0e-1" => -0.1,
      ".1"      => 0.1,
      ".1e+1"   => 1.0,
      ".1e-1"   => 0.01,
      "-.1e+1"  => -1.0,
      "-.1e-1"  => -0.01,
      " 1 00"   => 1,
      "  1  "   => 1,
      "  -1 "   => -1,
      " 1. 10 " => 1.0,
      "    1.0" => 1.0,
      " .1    " => 0.1,
      "  -1.1 " => -1.1,
      " -1 . 1" => -1.0
    }.each do |actual, expected|
      it "converts '#{actual}' to '#{expected}'" do
        expect(converter.(actual)).to eql(expected)
      end
    end
  end
end
