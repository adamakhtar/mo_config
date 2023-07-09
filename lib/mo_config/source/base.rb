module MoConfig
  class Source
    class Base
      def self.match?(source_type)
        self.type == source_type
      end

      def self.type
        # MoConfig::Reader::Yaml => :yaml
        self.name.split("::").last.downcase.to_sym
      end

      def self.match?(source)
        raise "You must implement this in the subclass"
      end

      def initialize(options)
        @options = options
      end

      def value(key)
        raise "You must implement this in the subclass"
      end

      def key?(key)
        raise "You must implement this in the subclass"
      end

      def description
        raise "You must implement this in the subclass"
      end

      private

      attr_reader :options
    end
  end
end