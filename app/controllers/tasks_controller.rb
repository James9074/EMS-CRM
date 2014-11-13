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
    if params[:task][:collab] == "1"
      if (params[:task][:number_to_complete].to_i < 1)
        params[:task][:number_to_complete] = 1
      end
      @task = Task.create params[:task]
      @task.assigned_to.clear
      params[:task][:assigned_to].each do |x|
        @task.assigned_to.push(User.where(id: x).first.name)
      end
      puts @task.assigned_to
      @task.save
      task_owner = User.where(name: @task.assigned_to).first
      TaskMailer.notify_new_task(task_owner, @task).deliver

    else
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
    end
    if !defined? @task
      flash[:notice] = "Please select a user or users first"
      #redirect_to new_task_path, error: "Not right..."
      @task = Task.create params[:task]

      @task_due_dates = Task.due_dates
      @task_types = Task.task_type
      @repeating_types = Task.repeating_type
      @task_owners = User.all.map(&:name)
      @leads = Lead.all.map(&:email)
      render :new

    else
      if @task.save
      redirect_to dashboard_path, flash: { notice: 'New Task Created'}
      else
      flash[:notice] = "Something is wrong"

      @task_due_dates = Task.due_dates
      @task_types = Task.task_type
      @repeating_types = Task.repeating_type
      @task_owners = User.all.map(&:name)
      @leads = Lead.all.map(&:email)


      render :new
      end
    end

  end

  def destroy
    Task.find(params[:id]).destroy
    redirect_to tasks_path, flash: { notice: 'Task Deleted'}
  end

  def update
    puts "Assigned to:"
    puts params[:task][:assigned_to]
    if params[:task][:assigned_to].is_a?(Array)
      params[:task][:assigned_to].reject! {|c| c.empty?}
    end
    puts "Params"
    puts params
    @task = Task.find params[:id]
    puts "Assigned to:"
    if params[:task][:assigned_to].length == 0
      params[:task][:assigned_to] = @task.assigned_to
    end
    if @task.update_attributes(params[:task])
      redirect_to dashboard_path, flash: { notice: 'Task Updated'}
      params[:task][:assigned_to].each do |x|

        task_owner = User.where(id: x).first.name
        #TaskMailer.notify_updated_task(task_owner, @task).deliver

      end
    else
      redirect_to dashboard_path, flash: { notice: 'Unable to update task.'}
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
