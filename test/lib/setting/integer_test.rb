require "test_helper"

class MoConfig::Setting::IntegerTest < ActiveSupport::TestCase
  setup do
    @source_klass = Class.new() do
      def initialize(data)
        @data = data
      end

      def key(name)
        @data[name.to_s]
      end
    end
  end

  test "valid? returns false and populates errors when coercion fails" do
    source = @source_klass.new("age" => nil)
    setting = build_setting(name: :age, source: source, coerce: true)

    assert_equal false, setting.valid?
    assert setting.errors.key?(:coercion_error)
    assert_equal ["can't convert nil into Integer"], setting.errors[:coercion_error]
  end

  test "valid? returns false and populates errors when validation fails" do
    source = @source_klass.new("age" => 10)
    setting = build_setting(name: :age, source: source, validations: {gt: 11})

    assert_equal false, setting.valid?
    assert setting.errors.key?(:validation_error)
    assert_equal ["must be greater than 11. Current value is 10"], setting.errors[:validation_error]
  end

  test "valid? returns true when coercion and validation is successful" do
    source = @source_klass.new("age" => "10")
    setting = build_setting(name: :age, source: source, coerce: true, validations: {gt: 9})

    assert_equal true, setting.valid?
    assert setting.errors.empty?
  end

  test "value returns the value when coercion and validation are successful" do
    source = @source_klass.new("age" => "10")
    setting = build_setting(name: :age, source: source, coerce: true, validations: {gt: 9})

    assert_equal 10, setting.value
  end

  test "value raises an error when coercion fails" do
    source = @source_klass.new("age" => nil)
    setting = build_setting(name: :age, source: source, coerce: true)

    assert_raises MoConfig::CoercionError, /can't coerce nil into Integer/ do
      setting.value
    end
  end

  test "value raises an error when validation fails" do
    source = @source_klass.new("age" => 10)
    setting = build_setting(name: :age, source: source, validations: {gt: 11})

    assert_raises MoConfig::ValidationError, /can't coerce nil into Integer/ do
      setting.value
    end
  end


  def build_setting(overrides={})
    attrs = {
      name: "age",
      config_name: "UserConfig",
      coerce: true,
      validations: {}
    }.merge(overrides)

    ::MoConfig::Setting::Integer.new(**attrs)
  end
end


