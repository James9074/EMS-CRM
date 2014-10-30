class TasksController < ApplicationController
  require 'will_paginate/array' 
  def new
    
    #@task = Task.new
    
    
    @task = Task.new
    @task_due_dates = Task.due_dates
    @task_types = Task.task_type
    @repeating_types = Task.repeating_type
    @task_owners = User.all.map(&:name)
    @leads = Lead.all.map(&:email)
    
    
  end

  def show
    @task = Task.find params[:id]
    @task_due_dates = Task.due_dates
    @task_types = Task.task_type
    @repeating_types = Task.repeating_type
    @task_owners = User.all.map(&:name)
    @leads = Lead.all.map(&:email)


  end

  def count(selectdate)
      Task.where(due_date: selectdate).count
     end
     helper_method :count
   def calendar
     
     
   #Filter tasks based on admin status
    if current_user.is_admin?
      @tasks = Task.all.order_by
    else
      @tasks = Task.all.where(assigned_to: current_user.name)
    end
    
    
  end
  
  def create
    params[:task][:assigned_to].reject! {|c| c.empty?}
    taskOwners = params[:task][:assigned_to]
    params[:task][:assigned_to].each do |x|
      if (params[:task][:number_to_complete].to_i < 1)
        params[:task][:number_to_complete] = 1

      end


      @task = Task.create params[:task]
      @task.assigned_to = User.where(id: x).first.name
      @task.save
      task_owner = User.where(name: @task.assigned_to).first
      TaskMailer.notify_new_task(task_owner, @task).deliver

    end
    if @task.save
      redirect_to tasks_path, flash: { notice: 'New Task Created'}
    else
      #flash[:notice] = "Somethig is wrong"
      render :new
    end
  end

  def destroy
    Task.find(params[:id]).destroy
    redirect_to tasks_path, flash: { notice: 'Task Deleted'}
  end

  def update
    @task = Task.find params[:id]
    if @task.update_attributes params[:task]
      task_owner = User.where(name: @task.assigned_to).first
      redirect_to tasks_path, flash: { notice: 'Task Updated'}
      TaskMailer.notify_updated_task(task_owner, @task).deliver
    else
      redirect_to task_path, flash: { notice: 'Unable to update task.'}
    end
  end

#Admin will see all tasks, while regular users will only see the tasks assigned to them.
  def index
    @users = User.all
    sort = params[:sort]
    order = params[:order]
    page = params[:page]
    order ||= :asc    
    sort ||= :task_name
    page ||= 1

    #Filter tasks based on admin status
    if current_user.is_admin?
      if params.key?(:due_date) && (params.key?(:username)) && params[:username][:name] != ""
        @tasks = Task.all.where(due_date: params[:due_date],assigned_to: params[:username][:name]).order_by(sort => order).page(params[:page])
      elsif (params.key?(:username)) && params[:username][:name] != ""
        @tasks = Task.all.where(assigned_to: params[:username][:name]).order_by(sort => order).page(params[:page])
      elsif params.key?(:due_date)
        @tasks = Task.all.where(due_date: params[:due_date]).order_by(sort => order).page(params[:page])
      else
        @tasks = Task.all.order_by(sort => order).page(params[:page])
      end

      if (params.key?(:username)) && params[:username][:name] != ""
        @filtername = params[:username][:name]
      else
        @filtername = ""
      end
    else
      @tasks = Task.all.where(assigned_to: current_user.name).order_by(sort => order).page(params[:page])
    end
  end

end
