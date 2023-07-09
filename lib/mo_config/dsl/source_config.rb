module MoConfig
  module Dsl
    class SourceConfig
      attr_reader :settings_config, :name, :options

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
end