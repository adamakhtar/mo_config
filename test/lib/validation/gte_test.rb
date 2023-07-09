require "test_helper"

class MoConfig::Validation::GteTest < ActiveSupport::TestCase
  test "is success when value is greater than contraint" do
    result, _ = MoConfig::Validation::Gte.call(10, 9)
    assert_equal :ok, result
  end

  test "is success when value is equal to the contraint" do
    result, _ = MoConfig::Validation::Gte.call(10, 10)
    assert_equal :ok, result
  end

  test "is failure when value is less than the contraint" do
    result, _ = MoConfig::Validation::Gte.call(10, 11)
    assert_equal :error, result
  end
end
