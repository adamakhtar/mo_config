module MoConfig
  class Source
    def for(type, options)
      source_class = [Yaml].find {|source_class| source_class.match?(type) }
      source_class.new(options)
    end
  end
end

