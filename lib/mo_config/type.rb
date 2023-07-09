module MoConfig
  module Type
    def self.for(name)
      if name.is_a?(Array)
        type_klass = Object.const_get("MoConfig::Type::Array")
        member_type_klass = Object.const_get("MoConfig::Type::#{name[0].capitalize}")
        klass.new(member_type: member_type_klass.new)
      else
        klass = Object.const_get("MoConfig::Type::#{name.capitalize}")
        klass.new
      end
    rescue NameError => e
      raise ArgumentError.new "#{name} is not a recognized setting type for use with MoConfig. #{e.message}"
    end
  end
end