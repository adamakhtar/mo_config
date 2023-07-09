module MoConfig
  module Type
    def self.for(name)
      klass = Object.const_get("MoConfig::Type::#{name.capitalize}")

    rescue NameError => e
      raise ArgumentError.new "#{name} is not a recognized setting type for use with MoConfig. #{e.message}"
    end
  end
end