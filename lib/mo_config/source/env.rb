module MoConfig
  class Source
    class Env < Base
      def self.match?(source_type)
        source_type == :env
      end

      def key?(key)
        data.key?(key.to_s)
      end

      def value(key)
        ENV[key.upcase.to_s]
      end

      def description
        "ENV"
      end
    end
  end
end