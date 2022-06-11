# frozen_string_literal: true

# Application consumer from which all Karafka consumers should inherit
# You can rename it if it would conflict with your current code base (in case you're integrating
# Karafka with other frameworks)
class ApplicationConsumer < Karafka::BaseConsumer
  Error = Class.new StandardError
  DEFAULT_EVENT_VERSION = 1

  private

  def validate_event!(payload)
    object_name, action = payload[:event_name].underscore.split('_')
    PayloadValidator.valid_event?(
      payload: payload,
      object_name: object_name,
      action: action,
      version: event_version
    )
  end

  def event_version
    DEFAULT_EVENT_VERSION
  end
end
