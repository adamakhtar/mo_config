module MoConfig
  class Coercion

    TRUE_VALUES = %w{true True TRUE T t yes Yes YES Y y 1}
    FALSE_VALUES = %w{false False FALSE F f no No NO N n 0}
    BOOLEAN_MAPPING = {}.merge(
      [1, true, TRUE_VALUES].flatten.to_h {|value| [value, true] },
      [0, false, FALSE_VALUES].flatten.to_h {|value| [value, false] }
    )

    def self.coerce(value, to:)
      case to
      when :string
        to_string(value)
      when :integer
        to_integer(value)
      when :float
        to_float(value)
      when :boolean
        to_boolean(value)
      when Array
        # e.g. [:integer] or [:boolean]
        to_array(value, to[0])
      else
        raise Error.new "Can not coerce into requested type. #{to.inspect} is not recognized."
      end
    end

    def self.to_string(value)
      value = value.nil? ? "" : value

      if value.respond_to?(:to_s)
        {result: :ok, value: value.to_s}
      else
        prepare_error_result(value, :string, "Can not coerce #{value.inspect} into type String.")
      end
    end

    def self.to_integer(value)
      value = Integer(value)
      {result: :ok, value: value}

    rescue ArgumentError, TypeError => e
      prepare_error_result(value, :integer, e.message)
    end

    def self.to_float(value)
      value = Float(value)
      {result: :ok, value: value}

    rescue ArgumentError, TypeError => e
      prepare_error_result(value, :float, e.message)
    end

    def self.to_boolean(value)
      value = BOOLEAN_MAPPING.fetch(value) do
        return prepare_error_result(
          value,
          :boolean,
          "Can not coerce #{value.inspect} into a boolean."
        )
      end

      {result: :ok, value: value}

    rescue ArgumentError, TypeError => e
      prepare_error_result(value, :boolean, e.message)
    end

    def self.to_array(value, member_type)
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

    def self.coerce_array_elements(elements, to:, raw_value:)
      initial_result = {coerced_array: [], error: nil}

      final_result = elements.each_with_object(initial_result) do |element, result|
        case coerce(element, to: to)
        in {result: :ok, value: coerced_value}
          result[:coerced_array] << coerced_value
          result
        in {result: :error} => error_result
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
        {result: :ok, value: final_result[:coerced_array]}
      end
    end

    def self.prepare_error_result(value, type, error_message)
      {
        result: :error,
        code: :can_not_coerce,
        type: type,
        original_value: value,
        message: error_message
      }
    end
  end
end