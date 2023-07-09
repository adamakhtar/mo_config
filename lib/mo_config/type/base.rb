module MoConfig
  module Type
    class Base
      def self.validate(value, validation_rules)
        errors = validation_rules.each_with_object([]) do |(rule_name, constraint), error_array|
          validator = self::VALIDATORS.find {|validator| validator.matches?(rule_name)}
          case validator.call(value, constraint)
          in [:error, validation_error]
            error_array << validation_error
          else
            next
          end
        end

        errors
      end
    end
  end
end