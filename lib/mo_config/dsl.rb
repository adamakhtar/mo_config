module MoConfig
  class Dsl
    def initialize(source, config_name)
      @source = source
      @config_name = config_name
      @compiled_settings = []
    end

    def compile_settings(&settings_block)
      instance_eval(&settings_block)

      @compiled_settings
    end

    def setting(name, options={})
      type_klass = MoConfig::Type.for(options[:type])
      settings_attrs = options.merge(
      name: name,
      config_name: @config_name,
      source: @source,
      type: type_klass
      )

      @compiled_settings << MoConfig::Setting.new(**settings_attrs)
    end
  end
end