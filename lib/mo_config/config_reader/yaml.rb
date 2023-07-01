module MoConfig
  class ConfigReader
    class Yaml < Base
      def self.match?(source)
        source.name == :yaml
      end

      def key?(key)
        data.key?(key.to_s)
      end

      def value(key)
        data[key.to_s]
      end

      def description
        "YAML #{source.options[:file]}"
      end

      private

      def data
        @data ||= YAML.load_file(source.options.fetch(:file))
      end
    end
  end
end