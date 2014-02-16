class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  field :task_name
  field :due_date
  field :assigned_to
  field :task_type
  field :lead_for_task
  field :number_to_complete
  field :number_completed
  field :description
  field :task_notes
  
  validates_presence_of :task_type, :task_name, :assigned_to, :due_date, :number_to_complete

  belongs_to :user

  DUE_DATES = [['Overdue','overdue'],['Asap', 'asap'],['To
day', 'today'],['Tomorrow', 'tomorrow'],['This week', 'this_week'],['Next week','next_week'],['Sometime later','sometime_later']]
  TASK_TYPES = [['Calls','calls'], ['Deals','deals'], ['Follow-ups', 'followups'], ['Quotes', 'quotes'], ['Other', 'other']]
  class << self
    def due_dates
      DUE_DATES
    end

    def task_type
      TASK_TYPES
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
