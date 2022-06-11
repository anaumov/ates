class PayloadValidator
  Error = Class.new StandardError

  def self.valid_event?(payload:, name:, action:, version:)
    validator = new(payload: payload, name: name, action: action, version: version)
    validator.valid?
  end

  def initialize(payload:, object_name:, action:, version:)
    @payload = payload
    @object_name = object_name
    @action = action
    @version = version
  end

  def valid?
    validation_result.success?
  end

  def validate!
    raise Error, "Invalid event #{validator.errors}" unless valid?
  end

  def errors
    validation_result.result
  end

  private

  attr_reader :payload, :object_name, :action, :version

  def validation_result
    SchemaRegistry.validate_event(payload, schema_path, version: version)
  end

  def schema_path
    [object_name.downcase, action].join('.')
  end
end
