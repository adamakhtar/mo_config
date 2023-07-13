module MoConfig
  class Source
    class Credentials < Base
      def self.match?(source_type)
        source_type == :credentials
      end

      def value(key)
        Rails.application.credentials.send(key.to_s)
      end
    end
  end
end