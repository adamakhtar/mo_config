module MoConfig
  class ConfigReader
    class Base
      def self.match?(source)
        raise "You must implement this in the subclass"
      end

      def initialize(source)
        @source = source
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

      attr_reader :source
    end
  end
end