require "mo_config/version"
require "mo_config/engine"

require "mo_config/errors"
require "mo_config/validation"
require "mo_config/validation/gt"
require "mo_config/coercion"
require "mo_config/type/base"
require "mo_config/type/integer"
require "mo_config/type/float"
require "mo_config/type/string"
require "mo_config/type/boolean"
require "mo_config/type/array"
require "mo_config/source"
require "mo_config/source/base"
require "mo_config/source/yaml"
require "mo_config/setting"
require "mo_config/setting/integer"
require "mo_config/config_reader"
require "mo_config/config_reader/base"
require "mo_config/config_reader/yaml"
require "mo_config/dsl"
require "mo_config/dsl/source_config"

module MoConfig
  class Error < StandardError; end
  class CoercionError < Error; end
  class MissingConfigError < Error; end
  class ValidationError < Error; end

  def self.included(base)
    base.class_eval do
      include Dsl
    end
  end
end