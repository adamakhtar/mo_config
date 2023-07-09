module MoConfig
  module Type
    module Integer
      VALIDATORS = [
        ::MoConfig::Validation::Gt
      ].freeze

      def self.validators
        VALIDATORS
      end

      def self.coerce(value)
        value = Integer(value)
        [:ok, value]

      rescue ArgumentError, TypeError => e
        [:error, e.message]
      end
    end
  end
end