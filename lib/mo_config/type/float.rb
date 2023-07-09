module MoConfig
  module Type
    class Float < Base
      VALIDATORS = [
        ::MoConfig::Validation::Gt
      ].freeze

      def coerce(value)
        value = Float(value)
        [:ok, value]

      rescue ArgumentError, TypeError => e
        [:error, e.message]
      end
    end
  end
end