module MoConfig
  module Validation
    class Format
      def self.matches?(shorthand_name)
        shorthand_name == :format
      end

      def self.call(value, regex)
        raise ArgumentError.new("#{regex.inspect} is not a valid regex.") unless regex.is_a?(Regexp)

        if value =~ regex
          [:ok]
        else
          [:error, "must match the format #{regex.inspect}. Current value is #{value.inspect}"]
        end
      end
    end
  end
end