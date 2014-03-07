class Event
  include Mongoid::Document
  field :name, type: String
  field :start_time, type: Time
  
  attr_accessible :name, :event_start_time

  def start_time
    event_start_time
  end
end
