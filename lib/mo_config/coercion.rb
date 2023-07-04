module MoConfig
  class Coercion

    TRUE_VALUES = %w{true True TRUE T t yes Yes YES Y y 1}
    FALSE_VALUES = %w{false False FALSE F f no No NO N n 0}
    BOOLEAN_MAPPING = {}.merge(
      TRUE_VALUES.to_h {|value| [value, true] },
      FALSE_VALUES.to_h {|value| [value, false] }
    )

    def self.coerce(string_or_nil, to:)
      case to
      when :string
        to_string(string_or_nil)
      when :integer
        to_integer(string_or_nil)
      when :float
        to_float(string_or_nil)
      when :boolean
        to_boolean(string_or_nil)
      when Array
        to_array(string_or_nil, to[0])
      else
        raise Error.new "Can not coerce into requested type. #{to.inspect} is not recognized."
      end
    end

    def self.to_string(string_or_nil)
      value = string_or_nil.nil? ? "" : string_or_nil
      {result: :ok, value: value}
    end

    def self.to_integer(string_or_nil)
      value = Integer(string_or_nil)
      {result: :ok, value: value}

    rescue ArgumentError, TypeError => e
      prepare_error_result(string_or_nil, :integer, e.message)
    end

    def self.to_float(string_or_nil)
      value = Float(string_or_nil)
      {result: :ok, value: value}

    rescue ArgumentError, TypeError => e
      prepare_error_result(string_or_nil, :float, e.message)
    end

    def self.to_boolean(string_or_nil)
      value = BOOLEAN_MAPPING.fetch(string_or_nil) do
        return prepare_error_result(
          string_or_nil,
          :boolean,
          "Can not coerce #{string_or_nil.inspect} into a boolean."
        )
      end

      {result: :ok, value: value}

    rescue ArgumentError, TypeError => e
      prepare_error_result(string_or_nil, :boolean, e.message)
    end

    def self.to_array(string_or_nil, member_type)
      if string_or_nil.nil? || string_or_nil.strip == ""
        return prepare_error_result(string_or_nil, :array, "Can not coerce #{string_or_nil.inspect} into an array")
      end

      valid_coercion_type_for_members = [:boolean, :float, :integer, :string].include?(member_type)

      if !valid_coercion_type_for_members
        raise MoConfig::Error, <<~ERROR.split("\n").join(" ")
          Invalid setting. Can not coerce #{string_or_nil.inspect} into array of elements
          of type #{member_type.inspect} as MoConfig does not support that type for arrays.
        ERROR
      end

      coerce_array_elements(string_or_nil, member_type)
    end

    def self.coerce_array_elements(string_or_nil, element_type)
      elements_strings = string_or_nil.split(",")
      elements_strings = elements_strings.map(&:strip)

      error = nil
      coerced_array = elements_strings.map do |element_string|
        case coerce(element_string, to: element_type)
        in {result: :ok, value: coerced_value}
          coerced_value
        in {result: :error} => error_result
          error = error_result
          break
        end
      end

      # If one of the elements could not be coerced tweak the error message to explain this
      # occured as part of coercing into array.
      if error
        error[:message] = <<~ERROR.split("/n").join(" ")
          Could not coerce the given string #{string_or_nil.inspect} into am array of
          #{element_type}s. The error occured when attempting to coerce the substring
          #{error[:original_value].inspect} into type #{element_type}. Please check and fix.
        ERROR

        error
      else
        {result: :ok, value: coerced_array}
      end
    end

    def self.prepare_error_result(string_or_nil, type, error_message)
      {
        result: :error,
        code: :can_not_coerce,
        type: type,
        original_value: string_or_nil,
        message: error_message
      }
    end
  end
end