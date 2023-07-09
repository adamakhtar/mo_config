require "test_helper"

class MoConfig::Type::IntegerTest < ActiveSupport::TestCase
  test "coerces valid string" do
    result, coerced_value = MoConfig::Type::Integer.new.coerce("10")
    assert_equal :ok, result
    assert_equal 10, coerced_value
  end

  test "coerces integer" do
    result, coerced_value = MoConfig::Type::Integer.new.coerce(10)
    assert_equal :ok, result
    assert_equal 10, coerced_value
  end

  test "errors with blank string" do
    result, _ = MoConfig::Type::Integer.new.coerce("")
    assert_equal :error, result
  end

  test "errors with nil" do
    result, _ = MoConfig::Type::Integer.new.coerce(nil)
    assert_equal :error, result
  end

  test "errors with boolean" do
    result, _ = MoConfig::Type::Integer.new.coerce(false)
    assert_equal :error, result
  end

  test "errors with array" do
    result, _ = MoConfig::Type::Integer.new.coerce([1,2])
    assert_equal :error, result
  end

  test "errors with hash" do
    result, _ = MoConfig::Type::Integer.new.coerce({})
    assert_equal :error, result
  end

  test "errors with invalid string" do
    result, _ = MoConfig::Type::Integer.new.coerce("10.5")
    assert_equal :error, result
  end
end