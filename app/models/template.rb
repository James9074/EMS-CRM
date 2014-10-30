class Template
  include Mongoid::Document
  include Mongoid::Timestamps
  field :task_name, type: String
  field :task_type, type: String
  field :repeating_type, type: String
  field :number_to_complete, type: Integer
  field :description, type: String
  field :id, type: Integer
  attr_accessible :about_attributes, :task_name, :task_type, :repeating_type, :number_to_complete, :description, :id
  validates_presence_of :task_type, :task_name, :number_to_complete, :id

end
