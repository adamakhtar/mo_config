require "test_helper"

class MoConfig::Type::ArrayTest < ActiveSupport::TestCase
  test "passes array through" do
    result = MoConfig::Type::Array.new().coerce([1, 2])
    assert_equal([:ok, [1, 2]], result)

    result = MoConfig::Type::Array.new().coerce([true,false])
    assert_equal([:ok, [true, false]], result)

    result = MoConfig::Type::Array.new().coerce([[1,2], [3,4]])
    assert_equal([:ok, [[1,2], [3,4]]], result)
  end

  test "coerces valid string into array of strings" do
    result = MoConfig::Type::Array.new().coerce("1, 2")
    assert_equal([:ok, ["1", "2"]], result)

    result = MoConfig::Type::Array.new().coerce("true,false")
    assert_equal([:ok, ["true", "false"]], result)

    result = MoConfig::Type::Array.new().coerce("1.5, 3.5")
    assert_equal([:ok, ["1.5", "3.5"]], result)
  end

  test "errors with types that can't be coerced into an array" do
    result, _ = MoConfig::Type::Array.new().coerce(1)
    assert_equal :error, result

    result, _ = MoConfig::Type::Array.new().coerce(true)
    assert_equal :error, result

    result, _ = MoConfig::Type::Array.new().coerce({a: 1})
    assert_equal :error, result

    result, _ = MoConfig::Type::Array.new().coerce(nil)
    assert_equal :error, result
  end
end
