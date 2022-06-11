class EventPayload
  def initialize(event, action)
    @event = event
    @action = action
  end

  def valid?
    validation_result.success?
  end

  def errors
    validation_result.result
  end

  def as_json
    {
      event_id: generate_event_id,
      event_version: current_event_version,
      event_name: build_event_name,
      event_time: Time.zone.now.to_s,
      producer: 'task_tracker',
      data: event_data
    }
  end

  private

  attr_reader :event, :action
  delegate :owner_name, :event_data, :current_event_version,  to: :event

  def schema_path
    [owner_name.downcase, action].join('.')
  end

  def generate_event_id
    SecureRandom.uuid
  end

  def build_event_name
    [event.owner_name, action].join('_').camelize
  end

  def validation_result
    SchemaRegistry.validate_event(as_json, schema_path, version: 1)
  end
end
