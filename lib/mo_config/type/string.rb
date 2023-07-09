module MoConfig
  module Type
    class String < Base
      VALIDATORS = [
        ::MoConfig::Validation::Gt
      ].freeze

      def self.coerce(value)
        value = value.nil? ? "" : value

        if value.respond_to?(:to_s)
          [:ok, value.to_s]
        else
          [:error, "Can't change #{value.inspect} into String"]
        end
      end
    end
  end
end