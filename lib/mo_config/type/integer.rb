module MoConfig
  module Type
    class Integer < Base
      VALIDATORS = [
        ::MoConfig::Validation::Gt
      ].freeze

      def coerce(value)
        value = Integer(value)
        [:ok, value]

      rescue ArgumentError, TypeError => e
        [:error, e.message]
      end
    end
  end
end