# frozen_string_literal: true

class Event
  Error = Class.new StandardError

  delegate :current_event_version, :event_data, to: :object

  def initialize(object)
    @object = object
  end

  def produce(action:, topic: nil)
    topic ||= build_topic
    payload = EventPayload.new(self, action)
    raise Error, "Invalid event #{payload.errors}" unless payload.valid?

    send_event(topic: topic, payload: event)
  end

  def owner_name
    object.class.name
  end

  private

  attr_reader :data, :object, :action

  def build_topic
    owner_name.downcase.pluralize
  end

  def send_event(topic:, payload:)
    WaterDrop::SyncProducer.call(payload.to_json, topic: topic)
  end
end
