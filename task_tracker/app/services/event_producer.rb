# frozen_string_literal: true

class EventProducer
  def self.send_cud_event(event:, **params)
    puts "CUD event sended. Payload: #{event}, params: #{params}"
  end

  def self.send_business_event(event:, **params)
    puts "Business event sended. Payload: #{event}, params: #{params}"
  end
end
