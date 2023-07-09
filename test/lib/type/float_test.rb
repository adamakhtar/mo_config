require "test_helper"

class MoConfig::Type::FloatTest < ActiveSupport::TestCase
  test "coerces valid string" do
    result, coerced_value = MoConfig::Type::Float.new.coerce("10.5")
    assert_equal :ok, result
    assert_equal 10.5, coerced_value
  end

  test "coerces integer" do
    result, coerced_value = MoConfig::Type::Float.new.coerce(10)
    assert_equal :ok, result
    assert_equal 10.0, coerced_value
  end

  test "coerces float" do
    result, coerced_value = MoConfig::Type::Float.new.coerce(10.5)
    assert_equal :ok, result
    assert_equal 10.5, coerced_value
  end

  test "errors with blank string" do
    result, _ = MoConfig::Type::Float.new.coerce("")
    assert_equal :error, result
  end

  test "errors with nil" do
    result, _ = MoConfig::Type::Float.new.coerce(nil)
    assert_equal :error, result
  end

  test "errors with boolean" do
    result, _ = MoConfig::Type::Float.new.coerce(false)
    assert_equal :error, result
  end

  test "errors with array" do
    result, _ = MoConfig::Type::Float.new.coerce([1,2])
    assert_equal :error, result
  end

  test "errors with hash" do
    result, _ = MoConfig::Type::Float.new.coerce({})
    assert_equal :error, result
  end

  test "errors with invalid string" do
    result, _ = MoConfig::Type::Float.new.coerce("A")
    assert_equal :error, result
  end
end