module MoConfig
  module Type
    class Array < Base
      VALIDATORS = [
        ::MoConfig::Validation::Gt
      ].freeze

      def coerce(value)
        valid_coercion_type_for_members = [:boolean, :float, :integer, :string].include?(member_type)
        if !valid_coercion_type_for_members
          raise MoConfig::Error, <<~ERROR.split("\n").join(" ")
            Invalid setting. Can not coerce #{value.inspect} into array of elements
            of type #{member_type.inspect} as MoConfig does not support that type for arrays.
          ERROR
        end

        prepared_error_result_for_invalid_value = prepare_error_result(
          value,
          :array,
          "Can not coerce #{value.inspect} into an array with members of type #{member_type}"
        )

        case value
        when Array
          return coerce_array_elements(
            value,
            to: member_type,
            raw_value: value
          )
        when String
          if value.strip == ""
            return prepared_error_result_for_invalid_value
          else
            arr_of_elements_as_strings = value.split(",").map(&:strip)
            return coerce_array_elements(
              arr_of_elements_as_strings,
              to: member_type,
              raw_value: value
            )
          end
        else
          return prepared_error_result_for_invalid_value
        end
      end

      def coerce_array_elements(elements, to:, raw_value:)
        initial_result = {coerced_array: [], error: nil}

        final_result = elements.each_with_object(initial_result) do |element, result|
          case coerce(element, to: to)
          in [:ok, coerced_value]
            result[:coerced_array] << coerced_value
            result
          in [:error] => error_result
            result[:error] = error_result
            result
          end
        end

        # If one of the elements could not be coerced the error will not have any information re:
        # this occured as part of coercing an array. Adjust it to provide more context.
        if final_result[:error]
          final_result[:error][:message] = <<~ERROR.split("/n").join(" ")
            Could not coerce the given value #{raw_value.inspect} into am array of
            #{to}s. The error occured when attempting to coerce the member
            #{final_result[:error][:original_value].inspect} into type #{to}. Please check and fix.
          ERROR

          final_result[:error]
        else
          prepare_ok_result(final_result[:coerced_array])
        end
      end
    end
  end
end