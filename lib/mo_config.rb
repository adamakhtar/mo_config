require "mo_config/version"
require "mo_config/engine"

require "mo_config/errors"
require "mo_config/validation"
require "mo_config/validation/gt"
require "mo_config/validation/gte"
require "mo_config/validation/lt"
require "mo_config/validation/lte"
require "mo_config/validation/format"
require "mo_config/type"
require "mo_config/type/base"
require "mo_config/type/integer"
require "mo_config/type/float"
require "mo_config/type/string"
require "mo_config/type/boolean"
require "mo_config/type/array"
require "mo_config/source"
require "mo_config/source/base"
require "mo_config/source/yaml"
require "mo_config/source/credentials"
require "mo_config/source/env"
require "mo_config/setting"
require "mo_config/dsl"

module MoConfig
  class Error < StandardError; end
  class CoercionError < Error; end
  class MissingConfigError < Error; end
  class ValidationError < Error; end

  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def source(name, options={}, &settings_block)
      sources[name] ||= MoConfig::Source.for(name, options)

      settings_config = Dsl.compile_source_and_settings(name, options, &settings_block)

      settings_for_source = settings_config.each_with_object({}) do |setting_config, settings_hash|
        type_klass = MoConfig::Type.for(setting_config[:type])
        settings_attrs = setting_config.merge(
          config_name: self.name,
          source: sources[name],
          type: type_klass
        )

        setting = MoConfig::Setting.new(**settings_attrs)
        settings_hash[setting.name] = setting
        settings_hash
      end

      settings_for_source.each_pair do |setting_name, setting|
        define_singleton_method setting.name.to_s do
          setting.value
        end
      end

      settings.merge!(settings_for_source)
    end

    def valid?
      settings.each_pair do |setting_name, setting|
        setting.valid?

        setting.errors.each_pair do |error_type, error_messages|
          errors.add(setting.name, type: error_type, error_messages: error_messages)
        end

        errors.any?
      end
    end

    def errors
      @errors ||= Errors.new
    end

    private

    def sources
      @sources ||= {}
    end

    def settings
      @settings ||= {}
    end
  end
end