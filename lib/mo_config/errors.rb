module MoConfig
  class Errors
    def initialize(items=[])
      @items = items
    end

    def all
      @items
    end

    def add(error)
      @items << error
    end

    def find_by(setting_name:)
      @items.find{|e| e[:setting_name] == setting_name }
    end

    def any?
      @items.any?
    end
  end
end