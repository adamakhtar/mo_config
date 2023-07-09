module MoConfig
  class Source
    class Yaml < Base
      def self.match?(source_type)
        source_type == :yaml
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

      def filepath
        options.fetch(:file)
      end

      def data
        @data ||= YAML.load_file(filepath)
      end
    end
  end
end