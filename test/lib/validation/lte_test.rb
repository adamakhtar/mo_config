require "test_helper"

class MoConfig::Validation::LteTest < ActiveSupport::TestCase
  test "is success when value is less than contraint" do
    result, _ = MoConfig::Validation::Lte.call(9, 10)
    assert_equal :ok, result
  end

  test "is success when value is equal to the contraint" do
    result, _ = MoConfig::Validation::Lte.call(10, 10)
    assert_equal :ok, result
  end

  test "is failure when value is greater than the contraint" do
    result, _ = MoConfig::Validation::Lte.call(11, 10)
    assert_equal :error, result
  end
end
