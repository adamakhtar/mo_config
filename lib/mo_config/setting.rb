module MoConfig
  class Setting
    attr_reader :name, :source_config, :type, :options
    def initialize(name:, source_config:, **options)
      @name = name
      @source_config = source_config

      @type = :string
      @type = options.delete(:type) if options.key?(:type)

      @options = options
    end
  end
end