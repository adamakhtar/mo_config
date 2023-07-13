module MoConfig
  class Setting
    attr_reader :name,
                :source,
                :config_name,
                :type,
                :validations,
                :errors

    def initialize(name:, type:, config_name:, source:, coerce: false, validations: {})
      @name = name.to_sym
      @coerce = coerce
      @config_name = config_name
      @source = source
      @validations = validations
      @raw_value = nil
      @coerced_value = nil
      @value = nil
      @type = type
      @errors = {}
    end

    def value!
      @value ||= begin
        coerce!
        validate!

        coerced_value
      end
    end

    def valid?
      case coerce
      in [:error, _]
        return false
      else
        # success.
      end

      case validate
      in [:ok]
        return true
      else
        return false
      end
    end

    private

    def coerce
      case type.coerce(raw_value)
      in [:ok, coerced_value] => ok_result
        self.coerced_value = coerced_value
        ok_result
      in [:error, error_messages] => error_result
        errors[:coercion_error] = [error_messages]
        # errors.add(name, type: type, error_messages: error_messages)
        error_result
      end
    end

    def coerce!
      case coerce
      in [:ok, _] => ok_result
        ok_result
      else
        raise MoConfig::CoercionError, "TODO"
      end
    end

    def validate
      validation_errors = type.validate(coerced_value, validations)
      if validation_errors.empty?
        [:ok]
      else
        errors[:validation_error] = validation_errors
        # errors.add(na                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     me, type: type, error_messages: validation_errors)
        [:invalid, name, validation_errors]
      end
    end

    def validate!
      case validate
      in [:ok]
        true
      else
        raise MoConfig::ValidationError, "TODO"
      end
    end

    attr_reader :coerced_value

    def coerced_value=(value)
      @coerced_value = value
    end

    def raw_value
      @raw_value ||= source.value(name)
    end
  end
end


