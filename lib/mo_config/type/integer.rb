module MoConfig
  module Type
    class Integer < Base
      VALIDATORS = [
        ::MoConfig::Validation::Gt
      ].freeze

      def self.coerce(value)
        value = Integer(value)
        [:ok, value]

      rescue ArgumentError, TypeError => e
        [:error, e.message]
      end
    end
  end
end