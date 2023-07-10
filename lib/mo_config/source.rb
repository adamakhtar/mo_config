module MoConfig
  class Source
    def self.for(type, options)
      source_class = [Yaml, Env].find {|source_class| source_class.match?(type) }
      source_class.new(options)
    end
  end
end

