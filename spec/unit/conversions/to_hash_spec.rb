# frozen_string_literal: true

RSpec.describe Necromancer::Conversions, "#to_hash" do
  it "exports default conversions to hash" do
    conversions = Necromancer::Conversions.new
    expect(conversions.to_hash).to eq({})

    conversions.load

    expect(conversions.to_hash.keys.sort).to eq([
      "array->array",
      "array->booleans",
      "array->bools",
      "array->floats",
      "array->integers",
      "array->ints",
      "array->numeric",
      "boolean->boolean",
      "boolean->integer",
      "date->date",
      "datetime->datetime",
      "float->float",
      "hash->array",
      "hash->hash",
      "integer->boolean",
      "integer->integer",
      "integer->string",
      "object->array",
      "range->range",
      "string->array",
      "string->bool_hash",
      "string->boolean",
      "string->boolean_hash",
      "string->booleans",
      "string->bools",
      "string->date",
      "string->datetime",
      "string->float",
      "string->float_hash",
      "string->floats",
      "string->hash",
      "string->int_hash",
      "string->integer",
      "string->integer_hash",
      "string->integers",
      "string->ints",
      "string->num_hash",
      "string->numeric",
      "string->numeric_hash",
      "string->range",
      "string->time",
      "time->time"
    ])
  end
end
