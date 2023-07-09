require "test_helper"

class MoConfig::Type::BooleanTest < ActiveSupport::TestCase
  test "coerces valid string" do
    assert_equal([:ok, true], MoConfig::Type::Boolean.new.coerce("true"))
    assert_equal([:ok, true], MoConfig::Type::Boolean.new.coerce("True"))
    assert_equal([:ok, true], MoConfig::Type::Boolean.new.coerce("TRUE"))
    assert_equal([:ok, true], MoConfig::Type::Boolean.new.coerce("T"))
    assert_equal([:ok, true], MoConfig::Type::Boolean.new.coerce("t"))
    assert_equal([:ok, true], MoConfig::Type::Boolean.new.coerce("yes"))
    assert_equal([:ok, true], MoConfig::Type::Boolean.new.coerce("Yes"))
    assert_equal([:ok, true], MoConfig::Type::Boolean.new.coerce("YES"))
    assert_equal([:ok, true], MoConfig::Type::Boolean.new.coerce("1"))

    assert_equal([:ok, false], MoConfig::Type::Boolean.new.coerce("false"))
    assert_equal([:ok, false], MoConfig::Type::Boolean.new.coerce("False"))
    assert_equal([:ok, false], MoConfig::Type::Boolean.new.coerce("FALSE"))
    assert_equal([:ok, false], MoConfig::Type::Boolean.new.coerce("F"))
    assert_equal([:ok, false], MoConfig::Type::Boolean.new.coerce("f"))
    assert_equal([:ok, false], MoConfig::Type::Boolean.new.coerce("no"))
    assert_equal([:ok, false], MoConfig::Type::Boolean.new.coerce("No"))
    assert_equal([:ok, false], MoConfig::Type::Boolean.new.coerce("NO"))
    assert_equal([:ok, false], MoConfig::Type::Boolean.new.coerce("0"))
  end

  test "errors with invalid string" do
    result, _ = MoConfig::Type::Boolean.new.coerce("abc")
    assert_equal :error, result
  end

  test "errors with blank string" do
    result, _ = MoConfig::Type::Boolean.new.coerce("")
    assert_equal :error, result
  end

  test "errors with nil" do
    result, _ = MoConfig::Type::Boolean.new.coerce(nil)
    assert_equal :error, result
  end

  test "coerces boolean" do
    assert_equal([:ok, true], MoConfig::Type::Boolean.new.coerce(true))
    assert_equal([:ok, false], MoConfig::Type::Boolean.new.coerce(false))
  end

  test "errors with array" do
    result, _ = MoConfig::Type::Boolean.new.coerce([1,2])
    assert_equal :error, result
  end

  test "errors with hash" do
    result, _ = MoConfig::Type::Boolean.new.coerce({})
    assert_equal :error, result
  end
end
