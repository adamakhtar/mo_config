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
  class DuplicateSettingError < Error; end
  class ReservedNameError < Error; end

  RESERVED_NAMES = %w{source setting settings sources valid? errors}

  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def source(name, options={}, &settings_block)
      sources[name] ||= MoConfig::Source.for(name, options)
      settings_config = Dsl.compile_source_settings(&settings_block)

      source_settings = settings_config.each_with_object([]) do |setting_config, settings_array|
        type_klass = MoConfig::Type.for(setting_config[:type])
        settings_attrs = setting_config.merge(
          config_name: self.name,
          source: sources[name],
          type: type_klass
        )

        setting = MoConfig::Setting.new(**settings_attrs)
        settings_array << setting
        settings_array
      end

      # Ensure no settings have reserved words as their names
      reserved_settings = source_settings.select { |setting| RESERVED_NAMES.include?(setting.name.to_s) }
                                       .map(&:name)

      if reserved_settings.any?
        raise ReservedNameError, <<~ERROR.split("\n").join(" ")
          The settings #{reserved_settings.join(", ")} in config class #{self.name} have names that
          are not allowed to be used. Please change them to something else.
          Settings can't be named any of the following: #{RESERVED_NAMES.join(", ")} names.
        ERROR
      end

      # Ensure there are no settings with the same name for this source or in previously
      # registered sources
      # {some_setting: [setting_a, setting_b] ...}
      settings_grouped_by_name = (settings + source_settings).group_by(&:name)
      duplicated_settings = settings_grouped_by_name.select {|name, group| group.size > 1 }.keys

      if duplicated_settings.any?
        raise DuplicateSettingError, <<~ERROR.split("\n").join(" ")
          Settings must have unique names. The following settings have been defined more than once
          in #{self.name}. #{duplicated_settings.join(", ")}. Please remove duplicates or change
          the setting names.
        ERROR
      end


      source_settings.each do |setting|
        # prevent a setting with the same name from being defined more than once.
        # Otherwise previous definitions will get clobbered.
        define_singleton_method setting.name.to_s do
          setting.value
        end
      end


      settings.concat(source_settings)
    end

    def valid?
      settings.each do |setting|
        setting.valid?

        setting.errors.each_pair do |error_type, error_messages|
          errors.add(setting.name, type: error_type, error_messages: error_messages)
        end
      end

      errors.any?
    end

    def errors
      @errors ||= Errors.new
    end

    private

    def sources
      @sources ||= {}
    end

    def settings
      @settings ||= []
    end
  end
end