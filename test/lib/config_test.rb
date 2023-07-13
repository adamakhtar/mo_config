require "test_helper"

class MoConfig::ConfigTest < ActiveSupport::TestCase
  test "configures settings and retrieves their values for yaml sources" do
    yaml_path = fixtures_path('sensitive_config.yaml')

    config_class = Class.new do
      include MoConfig
      source :yaml, file: yaml_path do
        setting "integer_setting", type: :integer
      end
    end

    assert_equal 10, config_class.integer_setting!
  end

  test "configures settings and retrieves their values for env sources" do
    config_class = Class.new do
      include MoConfig
      source :env do
        setting "integer_setting", type: :integer
      end
    end

    ClimateControl.modify INTEGER_SETTING: "10" do
      assert_equal 10, config_class.integer_setting!
    end
  end

  test "configures settings and retrieves their values for credential sources" do
    config_class = Class.new do
      include MoConfig
      source :credentials do
        setting "integer_setting", type: :integer
      end
    end

    assert_equal 10, config_class.integer_setting!
  end

  test "raises error when a setting with the same name is defined multiple times in the same source" do
    assert_raises MoConfig::DuplicateSettingError do
      Class.new do
        include MoConfig
        source :credentials do
          setting "integer_setting", type: :integer
          setting "integer_setting", type: :integer
        end
      end
    end
  end

  test "raises error when a setting with the same name is defined across mutliple sources" do
    assert_raises MoConfig::DuplicateSettingError do
      Class.new do
        include MoConfig
        source :credentials do
          setting "integer_setting", type: :integer
        end

        source :env do
          setting "integer_setting", type: :integer
        end
      end
    end
  end

  test "raises error when a setting has a name that is reserved" do
    assert_raises MoConfig::ReservedNameError do
      Class.new do
        include MoConfig
        source :credentials do
          setting "source", type: :integer
          setting "sources", type: :integer
          setting "setting", type: :integer
          setting "settings", type: :integer
          setting "valid?", type: :integer
          setting "errors", type: :integer
        end
      end
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
      config_class.blank_string_setting!
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
        # setting :array_as_string_setting, type: :array
      end
    end

    assert_equal 10, config_class.integer_as_string_setting!
    assert_equal 10.5, config_class.float_as_string_setting!
    assert_equal false, config_class.boolean_as_string_setting!
    # assert_equal [1, 2], config_class.array_as_string_setting
  end

  test "coerces settings that are already in the right type without erroring" do
    yaml_path = fixtures_path('sensitive_config.yaml')

    config_class = Class.new do
      include MoConfig

      source :yaml, file: yaml_path do
        setting :integer_setting, type: :integer
        setting :float_setting, type: :float
        setting :boolean_setting, type: :boolean
        # setting :array_setting, type: [:integer]
      end
    end

    assert_equal 10, config_class.integer_setting!
    assert_equal 10.5, config_class.float_setting!
    assert_equal false, config_class.boolean_setting!
    # assert_equal [1, 2], config_class.array_setting
  end

  test "valid? returns false if any seting are invalid" do
    yaml_path = fixtures_path('sensitive_config.yaml')

    config_class = Class.new do
      include MoConfig

      source :yaml, file: yaml_path do
        setting :float_as_string_setting, type: :integer
      end
    end

    config_class.valid?

    error = config_class.errors.error_messages_for(:float_as_string_setting, :coercion_error)
    assert error
  end
end
