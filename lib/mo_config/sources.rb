module MoConfig
  class Sources
    def initialize(sources=[])
      @sources = sources
    end

    def find_or_create(name, options)
      new_source = Source.for(name, options)
      existing_source = @sources.find {|source| source == new_source }

      return existing_source if existing_source

      @sources << new_source

      new_source
    end
  end
end
