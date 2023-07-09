require "test_helper"

class MoConfig::Validation::FormatTest < ActiveSupport::TestCase
  test "is success when value matches the contraint regex" do
    result, _ = MoConfig::Validation::Format.call("fizzbuzz", /buzz/)
    assert_equal :ok, result
  end

  test "is failure when value does not match the contraint regex" do
    result, _ = MoConfig::Validation::Format.call("fizzbuzz", /nomatch/)
    assert_equal :error, result
  end
end

