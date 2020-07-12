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
      }.to raise_error(Necromancer::ConversionTypeError)
    end
  end
end
