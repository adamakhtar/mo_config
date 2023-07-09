module MoConfig
  module Validation
    class Gt
      def self.matches?(shorthand_name)
        shorthand_name == :gt
      end

      def self.call(value, constraint)
        if value > constraint
          [:ok]
        else
          [:error, "must be greater than #{constraint}. Current value is #{value}"]
        end
      end
    end
  end
end