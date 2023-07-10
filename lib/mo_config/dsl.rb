module MoConfig
  class Dsl
    attr_reader :settings_config

    def self.compile_source_settings(&settings_block)
      dsl = new()
      dsl.compile_settings(&settings_block)
      dsl.settings_config
    end

    def initialize
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