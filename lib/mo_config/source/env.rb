module MoConfig
  class Source
    class Env < Base
      def self.match?(source_type)
        source_type == :env
      end

      def value(key)
        ENV[key.upcase.to_s]
      end
    end
  end
end