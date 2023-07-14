module MoConfig
  module Type
    class Array < Base
      VALIDATORS = [
        ::MoConfig::Validation::Gt,
        ::MoConfig::Validation::Gte,
        ::MoConfig::Validation::Lt,
        ::MoConfig::Validation::Lte
      ].freeze

      def coerce(value)
        if value.is_a?(::Array)
          [:ok, value]
        elsif value.is_a?(::String)
          [:ok, value.split(",").map(&:strip)]
        else
          [:error, "can't coerce #{value.inspect} into an array."]
        end
      end

      def member_type
        options[:member_type]
      end
    end
  end
end