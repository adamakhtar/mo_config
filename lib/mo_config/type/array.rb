module MoConfig
  module Type
    class Array < Base
      VALIDATORS = [
        ::MoConfig::Validation::Gt
      ].freeze

      SUPPORTED_MEMBER_TYPES = [
        MoConfig::Type::Integer,
        MoConfig::Type::Float,
        MoConfig::Type::String,
        MoConfig::Type::Boolean
      ].freeze

      def coerce(value)
        is_requested_member_type_supported = SUPPORTED_MEMBER_TYPES.any? do |supported_type|
         member_type.is_a?(supported_type)
       end

        if !is_requested_member_type_supported
          raise MoConfig::Error, <<~ERROR.split("\n").join(" ")
            Invalid setting. Can not coerce #{value.inspect} into array of elements
            of type #{member_type.inspect} as MoConfig does not support that type for arrays.
          ERROR
        end

        prepared_error_result_for_invalid_value = [
          :error,
          "can't coerce #{value.inspect} into an array with members of type #{member_type.inspect}"
        ]

        if value.is_a?(::Array)
          return coerce_array_elements(
            value,
            raw_value: value
          )
        elsif value.is_a?(::String)
          if value.strip == ""
            return prepared_error_result_for_invalid_value
          else
            arr_of_elements_as_strings = value.split(",").map(&:strip)
            return coerce_array_elements(
              arr_of_elements_as_strings,
              raw_value: value
            )
          end
        else
          return prepared_error_result_for_invalid_value
        end
      end

      def coerce_array_elements(elements, raw_value:)
        initial_result = {coerced_array: [], error: nil}

        final_result = elements.each_with_object(initial_result) do |element, result|
          case member_type.coerce(element)
          in [:ok, coerced_value]
            result[:coerced_array] << coerced_value
            result
          in [:error, _] => error_result
            result[:error] = error_result
            result
          end
        end

        # If one of the elements could not be coerced the error will not have any information re:
        # this occured as part of coercing an array. Adjust it to provide more context.
        if final_result[:error]
          new_error_message = <<~ERROR.split("/n").join(" ")
            Could not coerce the given value #{raw_value.inspect} into am array of
            #{member_type.name}.
          ERROR

          final_result[:error] = [:error, new_error_message]

          final_result[:error]
        else
          [:ok, final_result[:coerced_array]]
        end
      end

      def member_type
        options[:member_type]
      end
    end
  end
end