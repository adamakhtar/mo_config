module MoConfig
  module Validation
    class Gte
      def self.matches?(shorthand_name)
        shorthand_name == :gte
      end

      def self.call(value, constraint)
        if value.is_a?(Array) || value.is_a?(String)
          value = value.size
        end

        if value >= constraint
          [:ok]
        else
          [:error, "must be greater than or equal to #{constraint}. Current value is #{value.inspect}"]
        end
      end
    end
  end
end