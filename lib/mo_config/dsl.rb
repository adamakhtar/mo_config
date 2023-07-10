module MoConfig
  class Dsl
    attr_reader :settings_config, :name, :options

    def self.compile_source_and_settings(source_name, source_options, &settings_block)
      dsl = new(source_name, source_options)
      dsl.compile_settings(&settings_block)
      dsl.settings_config
    end

    def initialize(name, options={})
      @name = name
      @options = options
      @settings_config = []
    end

    def compile_settings(&settings_block)
      instance_eval(&settings_block)
    end

    def setting(name, options={})
      @settings_config << options.merge({name: name})
    end
  end
end