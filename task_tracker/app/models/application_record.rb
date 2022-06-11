class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  DEFAULT_EVENT_VERSION = 1

  def current_event_version
    DEFAULT_EVENT_VERSION
  end
end
