module MoConfig
  class ConfigReader
    def self.for(source)
      reader_strategy = [Yaml].find {|reader| reader.match?(source) }
      new(reader_strategy, source)
    end

    def initialize(reader_strategy, source)
      @strategy = reader_strategy.new(source)
    end

    def value_for(key, whiny: false)
      if strategy.key?(key)
        strategy.value(key)
      elsif whiny
        raise MoConfig::Error, "No key '#{key.to_s.inspect}' found in config: #{strategy.description}"
      end
    end

    def key_exists?(key)
      strategy.key?(key)
    end

    private

    attr_reader :strategy
  end
end
