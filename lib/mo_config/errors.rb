module MoConfig
  class Errors

    # @items stores errors keyed by a name, then error type and then the error messages.
    # E.g.
    # errors = {
    #   password: {
    #     coercion_error: ['cannot coerce nil into integer'],
    #     validation_error: ['must be greater than 5. Got nil.']
    #   }
    # }
    def initialize()
      @items = Hash.new{|h,k| h[k] = {} }
    end

    def all
      @items
    end

    # name: name of setting e.g. :password
    # type: type of error e.g. :validation_error, :coercion_error
    # error_messages: array of error message strings
    # e.g ['must be greater than...', 'must be less than ...']
    def add(name, type:, error_messages:)
      error_messages_for(name, type) << error_messages
    end

    def errors_for(name)
      @items[name] ||= Hash.new{|h,k| h[k] = {} }
    end

    def error_messages_for(name, error_type)
      errors_for(name)[error_type] ||= []
      errors_for(name)[error_type]
    end

    def any?
      @items.any?
    end

    def none?
      @items.empty?
    end

    def full_messages_for(name)
      messages_str = ""
      @items[name].each_pair do |error_type, error_messages|
        messages_str += " " + error_messages.join(". ").strip
      end
      messages_str
    end
  end
end

