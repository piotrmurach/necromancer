# frozen_string_literal: true

RSpec.describe Necromancer::DateTimeConverters, "#call" do
  describe ":string -> :date" do
    subject(:converter) { described_class::StringToDateConverter.new(:string, :date) }
    {
      "" => "",
      "1-1-2015" => Date.parse("2015/01/01"),
      "2014/12/07" => Date.parse("2014/12/07"),
      "2014-12-07" => Date.parse("2014/12/07")
    }.each do |actual, expected|
      it "converts #{actual.inspect} to range type" do
        expect(converter.call(actual)).to eql(expected)
      end
    end

    it "fails to convert in strict mode" do
      expect {
        converter.("2014 - 12 - 07", strict: true)
      }.to raise_error(Necromancer::ConversionTypeError,
                       "'2014 - 12 - 07' could not be converted from `string` into `date`")
    end
  end

  describe ":string -> :datetime" do
    subject(:converter) { described_class::StringToDateTimeConverter.new(:string, :datetime) }

    {
      "" => "",
      "2014/12/07" => DateTime.parse("2014/12/07"),
      "2014-12-07" => DateTime.parse("2014-12-07"),
      "7th December 2014" => DateTime.parse("2014-12-07"),
      "7th December 2014 17:19:44" => DateTime.parse("2014-12-07 17:19:44"),
    }.each do |actual, expected|
      it "converts #{actual.inspect} to range type" do
        expect(converter.call(actual)).to eql(expected)
      end
    end

    it "fails to convert in strict mode" do
      expect {
        converter.call("2014 - 12 - 07", strict: true)
      }.to raise_error(Necromancer::ConversionTypeError)
    end
  end

  describe ":string -> :time" do
    subject(:converter) { described_class::StringToTimeConverter.new(:string, :time) }

    {
      "" => "",
     "01/01/2015" => Time.parse("01/01/2015"),
     "01/01/2015 08:35" => Time.parse("01/01/2015 08:35"),
     "12:35" => Time.parse("12:35"),
    }.each do |actual, expected|
      it "converts #{actual.inspect} to range type" do
        expect(converter.call(actual)).to eql(expected)
      end
    end

    it "fails to convert in strict mode" do
      expect {
        converter.("11-13-2015", strict: true)
      }.to raise_error(Necromancer::ConversionTypeError)
    end
  end
end
