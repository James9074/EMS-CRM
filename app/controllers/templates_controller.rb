class TemplatesController < InheritedResources::Base
  def new
    @template = Template.new
    @task_types = Task.task_type
  end
   def edit
   @template = Template.find params[:id]
   @task_types = Task.task_type
  end

end