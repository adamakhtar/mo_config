module MoConfig
  module Dsl
    def self.included(base)
      base.class_eval do
        extend ClassMethods
      end
    end

    module ClassMethods
      def source(name, options={}, &settings_block)
        source_config = SourceConfig.new(name, options)
        source_config.compile_settings(&settings_block)

        sources[name] ||= MoConfig::Source.for(name, options)

        settings_for_source = source_config.settings_config.each_with_object({}) do |setting_config, settings_hash|
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

      def settings
        @settings ||= {}
      end

      def sources
        @sources ||= {}
      end
    end
  end
end