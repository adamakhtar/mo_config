module MoConfig
  module Validation
    class Gt
      def self.matches?(shorthand_name)
        shorthand_name == :gt
      end

      def self.call(value, constraint)
        if value.is_a?(Array) || value.is_a?(String)
          value = value.size
        end

        if value > constraint
          [:ok]
        else
          [:error, "must be greater than #{constraint}. Current value is #{value.inspect}"]
        end
      end
    end
  end
end