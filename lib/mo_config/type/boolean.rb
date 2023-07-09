module MoConfig
  module Type
    class Boolean < Base
      TRUE_VALUES = %w{true True TRUE T t yes Yes YES Y y 1}
      FALSE_VALUES = %w{false False FALSE F f no No NO N n 0}
      BOOLEAN_MAPPING = {}.merge(
        [1, true, TRUE_VALUES].flatten.to_h {|value| [value, true] },
        [0, false, FALSE_VALUES].flatten.to_h {|value| [value, false] }
      )

      VALIDATORS = [
        ::MoConfig::Validation::Gt
      ].freeze

      def coerce(value)
        value = BOOLEAN_MAPPING.fetch(value) do
          return [:error, "can't change #{value.inspect} into boolean."]
        end

        [:ok, value]
      rescue ArgumentError, TypeError => e
        [:error, e.message]
      end
    end
  end
end