# frozen_string_literal: true

class Event
  def initialize(data)
    @data = data
  end

  def produce(topic)
    client.produce_sync(topic: topic, payload: data.to_json)
    client.close
  end

  private

  attr_reader :data

  def client
    @client ||= WaterDrop::Producer.new do |config|
      config.deliver = true
      config.kafka = { 'bootstrap.servers': 'localhost:9092' }
    end
  end
end
