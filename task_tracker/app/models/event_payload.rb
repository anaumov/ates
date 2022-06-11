class EventPayload
  delegate :validate!, :valid?, :errors, to: :validator

  def initialize(event, action)
    @event = event
    @action = action
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

  def generate_event_id
    SecureRandom.uuid
  end

  def build_event_name
    [event.owner_name, action].join('_').camelize
  end

  def validator
    @validator ||= PayloadValidator.new(
      payload: as_json,
      object_name: owner_name,
      action: action,
      version: current_event_version
    )
  end
end
