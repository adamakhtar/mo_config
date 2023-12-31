module MoConfig
  module Type
    class Base
      def initialize(options={})
        @options = options
      end

      def validate(value, validation_rules)
        errors = validation_rules.each_with_object([]) do |(rule_name, constraint), error_array|
          validator = self.class::VALIDATORS.find {|validator| validator.matches?(rule_name)}
          case validator.call(value, constraint)
          in [:error, validation_error]
            error_array << validation_error
          else
            next
          end
        end

        errors
      end

      def name
        self.class.name.split("::").last.downcase.to_sym
      end

      private

      attr_reader :options
    end
  end
end