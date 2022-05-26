# frozen_string_literal: true

class Event
  def initialize(object)
    @object = object
  end

  def produce(action:)
    send_event(topic: topic, payload: {
      name: build_name(action: action),
      data: object.event_data 
    })
  end

  private

  attr_reader :data, :object, :action

  def topic
    object_class_name.downcase.pluralize
  end

  def object_class_name
    object.class.name
  end

  def build_name(action:)
    [object_class_name, action].join('_').camelize
  end

  def send_event(topic:, payload:)
    client.produce_sync(topic: topic, payload: payload.to_json)
    client.close
  end

  def client
    @client ||= WaterDrop::Producer.new do |config|
      config.deliver = true
      config.kafka = { 'bootstrap.servers': 'localhost:9092' }
    end
  end
end
