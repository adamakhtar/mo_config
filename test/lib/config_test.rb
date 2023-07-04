require "test_helper"

class MoConfig::ConfigTest < ActiveSupport::TestCase
  test "configures settings and retrieves their values" do
    yaml_path = fixtures_path('sensitive_config.yaml')

    config_class = Class.new do
      include MoConfig
      source :yaml, file: yaml_path do
        setting :string_setting
      end
    end

    assert_equal "abc", config_class.string_setting
  end

  test "raises error when setting's config is missing" do
    yaml_path = fixtures_path('sensitive_config.yaml')

    config_class = Class.new do
      include MoConfig

      source :yaml, file: yaml_path do
        setting :does_not_exist_in_yaml_file
      end
    end

    assert_raises MoConfig::MissingConfigError do
      config_class.does_not_exist_in_yaml_file
    end
  end

  test "raises error when a settings value can not be coerced to desired type" do
    yaml_path = fixtures_path('sensitive_config.yaml')

    config_class = Class.new do
      include MoConfig

      source :yaml, file: yaml_path do
        setting :blank_string_setting, type: :integer
      end
    end

    assert_raises MoConfig::CoercionError do
      config_class.blank_string_setting
    end
  end

  test "coerces settings into specified types" do
    yaml_path = fixtures_path('sensitive_config.yaml')

    config_class = Class.new do
      include MoConfig

      source :yaml, file: yaml_path do
        setting :integer_as_string_setting, type: :integer
        setting :float_as_string_setting, type: :float
        setting :boolean_as_string_setting, type: :boolean
        setting :array_as_string_setting, type: [:integer]
      end
    end

    assert_equal 10, config_class.integer_as_string_setting
    assert_equal 10.5, config_class.float_as_string_setting
    assert_equal false, config_class.boolean_as_string_setting
    assert_equal [1, 2], config_class.array_as_string_setting
  end

  test "coerces settings that are already in the right type without erroring" do
    yaml_path = fixtures_path('sensitive_config.yaml')

    config_class = Class.new do
      include MoConfig

      source :yaml, file: yaml_path do
        setting :integer_setting, type: :integer
        setting :float_setting, type: :float
        setting :boolean_setting, type: :boolean
        setting :array_setting, type: [:integer]
      end
    end

    assert_equal 10, config_class.integer_setting
    assert_equal 10.5, config_class.float_setting
    assert_equal false, config_class.boolean_setting
    assert_equal [1, 2], config_class.array_setting
  end

  test "valid? returns false if config is missing" do
    yaml_path = fixtures_path('sensitive_config.yaml')

    config_class = Class.new do
      include MoConfig

      source :yaml, file: yaml_path do
        setting :does_not_exist_in_yaml_file
      end
    end

    config_class.valid?

    error = config_class.errors.find_by(setting_name: :does_not_exist_in_yaml_file)
    assert error
    assert_equal :config_missing, error[:code]
  end

  test "valid? returns false if seting can not be coerced" do
    yaml_path = fixtures_path('sensitive_config.yaml')

    config_class = Class.new do
      include MoConfig

      source :yaml, file: yaml_path do
        setting :float_as_string_setting, type: :integer
      end
    end

    config_class.valid?

    error = config_class.errors.find_by(setting_name: :float_as_string_setting)
    assert error
    assert_equal :can_not_coerce, error[:code]
  end
end
