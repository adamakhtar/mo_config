require "test_helper"

class MoConfig::Validation::LtTest < ActiveSupport::TestCase
  test "is success when value is less than contraint" do
    result, _ = MoConfig::Validation::Lt.call(9, 10)
    assert_equal :ok, result
  end

  test "is failure when value is equal to the contraint" do
    result, _ = MoConfig::Validation::Lt.call(10, 10)
    assert_equal :error, result
  end

  test "is failure when value is greater than the contraint" do
    result, _ = MoConfig::Validation::Lt.call(11, 10)
    assert_equal :error, result
  end
end
