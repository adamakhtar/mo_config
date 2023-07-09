require "test_helper"

class MoConfig::Type::ArrayTest < ActiveSupport::TestCase
  test "coerces valid string" do
    result = MoConfig::Type::Array.new(member_type: MoConfig::Type::Integer.new).coerce("1, 2")
    assert_equal([:ok, [1, 2]], result)

    result = MoConfig::Type::Array.new(member_type: MoConfig::Type::Boolean.new).coerce("true,false")
    assert_equal([:ok, [true, false]], result)

    result = MoConfig::Type::Array.new(member_type: MoConfig::Type::Float.new).coerce("1.5, 3.5")
    assert_equal([:ok, [1.5, 3.5]], result)
  end

  test "to_array coerces array with valid members" do
    result = MoConfig::Type::Array.new(member_type: MoConfig::Type::Integer.new).coerce([1, 2])
    assert_equal([:ok, [1, 2]], result)

    result = MoConfig::Type::Array.new(member_type: MoConfig::Type::Boolean.new).coerce([true,false])
    assert_equal([:ok, [true, false]], result)

    result = MoConfig::Type::Array.new(member_type: MoConfig::Type::Float.new).coerce([1.5, 3.5])
    assert_equal([:ok, [1.5, 3.5]], result)
  end

  test "to_array raises error with array with invalid members" do
    result, _ = MoConfig::Type::Array.new(member_type: MoConfig::Type::Integer.new).coerce(["1.1", "2.2"])
    assert_equal :error, result

    result, _ = MoConfig::Type::Array.new(member_type: MoConfig::Type::Boolean.new).coerce(["A", "B"])
    assert_equal :error, result

    result, _ = MoConfig::Type::Array.new(member_type: MoConfig::Type::Float.new).coerce([true, false])
    assert_equal :error, result
  end

  test "to_array raises error with invalid string" do
    result, _ = MoConfig::Type::Array.new(member_type: MoConfig::Type::Integer.new).coerce("abc")
    assert_equal :error, result
  end

  test "to_array raises error with empty string" do
    result, _ = MoConfig::Type::Array.new(member_type: MoConfig::Type::Integer.new).coerce("")
    assert_equal :error, result
  end

  test "to_array raises error with nil" do
    result, _ = MoConfig::Type::Array.new(member_type: MoConfig::Type::Integer.new).coerce(nil)
    assert_equal :error, result
  end
end
