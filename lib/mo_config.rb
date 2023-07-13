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
require "mo_config/sources"
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
      source = sources.find_or_create(name, options)
      dsl = Dsl.new(source, self.name)
      source_settings = dsl.compile_settings(&settings_block)

      source_settings.each do |setting|
        # prevent creating settings as the same name as other core methods.
        if RESERVED_NAMES.include?(setting.name.to_s)
          raise ReservedNameError, <<~ERROR.split("\n").join(" ")
            The name "#{setting.name}"" has been used to define a setting in the config class
            #{self.name} but this is a reserved word and can not be used. Please rename it. These
            are all reserved words: #{RESERVED_NAMES.join(", ")}.
          ERROR
        end

        # prevent defining a setting with the same name more than once. Otherwise previous previous
        # definitions will get clobbered.
        if respond_to? setting.name.to_s
          raise DuplicateSettingError, <<~ERROR.split("\n").join(" ")
            Settings must have unique names. The setting "#{setting.name}" has been defined more
            than once in #{self.name}. Plese remove or rename it.
          ERROR
        end

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
      @sources ||= Sources.new
    end

    def settings
      @settings ||= []
    end
  end
end