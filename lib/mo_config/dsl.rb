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

        # TODO move to Setting.initalize_many(....) ?
        settings_for_source = source_config.settings_config.each_with_object({}) do |setting_config, settings_hash|
          setting = MoConfig::Setting.new(**setting_config)
          settings_hash[setting.name] = setting
          settings_hash
        end

        settings.merge!(settings_for_source)

        define_settings_methods
      end

      def define_settings_methods
        settings.each_pair do |setting_name, setting|
          config_reader = ConfigReader.for(setting.source_config)

          define_singleton_method setting.name.to_s do
            if !config_reader.key_exists?(setting.name.to_s)
              raise MoConfig::MissingConfigError, "No config found for #{setting.name}."
            end

            value = config_reader.value_for(setting.name.to_s)

            case Coercion.coerce(value, to: setting.type)
            in {result: :ok, value: coerced_value}
              value = coerced_value
            in {result: :error}
              raise MoConfig::CoercionError, <<~ERROR.split("/n").join(" ")
                Can not coerce #{setting.name} in #{self.name} to type #{setting.type}.
                #{setting.name}'s original value is #{value.inspect} (#{value.class.name}).
                This is not coercible.
              ERROR
            end

            # TODO perform validation here

            value
          end
        end

        def valid?
          settings.each_pair do |setting_name, setting|
            base_error = {
              code: nil,
              setting_name: setting_name,
              source: setting.source_config.name,
              source_path: setting.options[:file],
              message: nil
            }

            # TODO - consider memoizing the config_readers as they could do IO and read files
            config_reader = ConfigReader.for(setting.source_config)

            if !config_reader.key_exists?(setting.name.to_s)
              error = base_error.merge(code: :config_missing)
              errors.add(error)
              next
            end

            value = config_reader.value_for(setting.name.to_s)

            case Coercion.coerce(value, to: setting.type)
            in {result: :error} => coercion_error
              error = base_error.merge(coercion_error.slice(:code, :message))
              errors.add(error)
              next
            end

            # TODO perform validation here
          end

          !self.errors.any?
        end
      end

      def errors
        @errors ||= Errors.new([])
      end

      private

      def settings
        @settings ||= {}
      end
    end
  end
end