require "test_helper"

class MoConfig::CoercionTest < ActiveSupport::TestCase

  test "to_integer coerces valid string" do
    assert_equal({result: :ok, value: 10}, MoConfig::Coercion.to_integer("10"))
  end

  test "to_integer raises error with blank string" do
    result = MoConfig::Coercion.to_integer("")

    assert_equal :error, result[:result]
  end

  test "to_integer raises error with nil" do
    result = MoConfig::Coercion.to_integer(nil)
    assert_equal :error, result[:result]
  end

  test "to_integer raises error with invalid string" do
    result = MoConfig::Coercion.to_integer("10.5")
    assert_equal :error, result[:result]
  end


  test "to_float coerces valid string" do
    assert_equal({result: :ok, value: 10.5}, MoConfig::Coercion.to_float("10.5"))
  end

  test "to_float raises error with invalid string" do
    result = MoConfig::Coercion.to_float("abc")
    assert_equal :error, result[:result]
  end

  test "to_float raises error with blank string" do
    result = MoConfig::Coercion.to_float("")
    assert_equal :error, result[:result]
  end

  test "to_float raises error with nil" do
    result = MoConfig::Coercion.to_float(nil)
    assert_equal :error, result[:result]
  end


  test "to_boolean coerces valid string" do
    assert_equal({result: :ok, value: true}, MoConfig::Coercion.to_boolean("true"))
    assert_equal({result: :ok, value: true}, MoConfig::Coercion.to_boolean("True"))
    assert_equal({result: :ok, value: true}, MoConfig::Coercion.to_boolean("TRUE"))
    assert_equal({result: :ok, value: true}, MoConfig::Coercion.to_boolean("T"))
    assert_equal({result: :ok, value: true}, MoConfig::Coercion.to_boolean("t"))
    assert_equal({result: :ok, value: true}, MoConfig::Coercion.to_boolean("yes"))
    assert_equal({result: :ok, value: true}, MoConfig::Coercion.to_boolean("Yes"))
    assert_equal({result: :ok, value: true}, MoConfig::Coercion.to_boolean("YES"))
    assert_equal({result: :ok, value: true}, MoConfig::Coercion.to_boolean("1"))

    assert_equal({result: :ok, value: false}, MoConfig::Coercion.to_boolean("false"))
    assert_equal({result: :ok, value: false}, MoConfig::Coercion.to_boolean("False"))
    assert_equal({result: :ok, value: false}, MoConfig::Coercion.to_boolean("FALSE"))
    assert_equal({result: :ok, value: false}, MoConfig::Coercion.to_boolean("F"))
    assert_equal({result: :ok, value: false}, MoConfig::Coercion.to_boolean("f"))
    assert_equal({result: :ok, value: false}, MoConfig::Coercion.to_boolean("no"))
    assert_equal({result: :ok, value: false}, MoConfig::Coercion.to_boolean("No"))
    assert_equal({result: :ok, value: false}, MoConfig::Coercion.to_boolean("NO"))
    assert_equal({result: :ok, value: false}, MoConfig::Coercion.to_boolean("0"))
  end

  test "to_boolean raises error with invalid string" do
    result = MoConfig::Coercion.to_boolean("abc")
    assert_equal :error, result[:result]
  end

  test "to_boolean raises error with blank string" do
    result = MoConfig::Coercion.to_boolean("")
    assert_equal :error, result[:result]
  end

  test "to_boolean raises error with nil" do
    result = MoConfig::Coercion.to_boolean(nil)
    assert_equal :error, result[:result]
  end


  test "to_array coerces valid string" do
    assert_equal({result: :ok, value: [1, 2]}, MoConfig::Coercion.to_array("1, 2", :integer))
    assert_equal({result: :ok, value: [true, false]}, MoConfig::Coercion.to_array("true,false", :boolean))
    assert_equal({result: :ok, value: [1.5, 3.5]}, MoConfig::Coercion.to_array("1.5, 3.5", :float))
  end

  test "to_array raises error with invalid string" do
    result = MoConfig::Coercion.to_array("abc", :integer)
    assert_equal :error, result[:result]
  end

  test "to_array raises error with empty string" do
    result = MoConfig::Coercion.to_array("", :integer)
    assert_equal :error, result[:result]
  end

  test "to_array raises error with nil" do
    result = MoConfig::Coercion.to_array(nil, :integer)
    assert_equal :error, result[:result]
  end
end
