module MoConfig
  module Validation
    class Lte
      def self.matches?(shorthand_name)
        shorthand_name == :lte
      end

      def self.call(value, constraint)
        if value.is_a?(Array) || value.is_a?(String)
          value = value.size
        end

        if value <= constraint
          [:ok]
        else
          [:error, "must be less than or equal to #{constraint}. Current value is #{value.inspect}"]
        end
      end
    end
  end
end