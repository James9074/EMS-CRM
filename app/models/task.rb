class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  field :task_name
  field :due_date
  field :assigned_to
  field :task_type
  field :repeating_type
  field :lead_for_task
  field :number_to_complete
  field :number_completed
  field :description
  field :task_notes
  field :collab
  
  
  validates_presence_of :task_type, :task_name, :assigned_to, :due_date, :number_to_complete, :repeating_type

  belongs_to :user
  
  def start_time
    taskdate = Date.strptime(due_date.to_s,"%m/%d/%Y")
    #DateTime.parse(taskdate) 
  end
  
  DUE_DATES = [['Overdue','overdue'],['Asap', 'asap'],['To
day', 'today'],['Tomorrow', 'tomorrow'],['This week', 'this_week'],['Next week','next_week'],['Sometime later','sometime_later']]
  TASK_TYPES = ['Calls','Quotes','Sales','IT','Accounting','Other']
  REPEATING_TYPES = [['None', 'none'],['Daily','daily'],['Weekly','weekly'],['Monthly','monthly']]
  class << self
    def due_dates
      DUE_DATES
    end

    def task_type
      TASK_TYPES
    end

    def repeating_type
      REPEATING_TYPES
    end


  end

  def complete?
        if number_to_complete.to_i - number_completed.to_i <= 0
          return true
        else
          return false
        end
    end
    
  def percent_done
   return (number_completed.to_i/number_to_complete.to.i )*100
  end
end
