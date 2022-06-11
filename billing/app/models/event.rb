# frozen_string_literal: true

class Event
  def initialize(object)
    @object = object
  end

  def produce(action:, topic: nil)
    topic ||= build_topic
    send_event(topic: topic, payload: {
      name: build_name(action: action),
      data: object.event_data
    })
  end

  private

  attr_reader :data, :object, :action

  def build_topic
    object_class_name.downcase.pluralize
  end

  def object_class_name
    object.class.name
  end

  def build_name(action:)
    [object_class_name, action].join('_').camelize
  end

  def send_event(topic:, payload:)
    WaterDrop::SyncProducer.call(payload.to_json, topic: topic)
  end
end
