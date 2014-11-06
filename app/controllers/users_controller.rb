class UsersController < Devise::RegistrationsController
def calendar
     
     
   #Filter tasks based on admin status
    if current_user.is_admin?
      @tasks = Task.all.order_by
    else
      @tasks = Task.all.where(assigned_to: current_user.name)
    end
    
    
  end
  def count(selectdate)
      Task.where(due_date: selectdate).count
     end
     helper_method :count
  def dashboard
    @leads = Lead.all.where(lead_owner: current_user.email).to_a
    #Admin will see all tasks, while regular users will only see the tasks assigned to them.
  if current_user.try(:admin)
      @tasks = Task.all.to_a
            params.key?(:role) ? @users = User.all.where(organization_role: params[:role]) : @users = User.all

      if (params.key?(:username)) && params[:username][:name] != ""
        #@users = User.all.where(name: params[:user])
        @tasks = Array.new
        @tasks += Task.all.where(assigned_to: params[:username][:name])
        @tasks.each do |task|
          puts task.task_name + "aname"
        end
        @filtername = params[:username][:name]
        Task.all.each do |x|
          puts "------------------"
          if x.assigned_to.is_a?(Array)
            userExists = false
            x.assigned_to.each do |user|
              puts user
              if(user.eql?(params[:username][:name]))
                puts "EQUAL"
                userExists = true
                break
              else
                puts "NOPE: " + user + " != " + params[:username][:name]
              end
            end
            if(userExists)
              puts "ADD: " + x.task_name
              puts "ISARRAY? " + @tasks.class.to_s
              #@tasks += Array.wrap(x)

              break
            end


          #elsif x.assigned_to != params[:username][:name]
           # puts "DELETE TASK: " + x.assigned_to
           # @temptasks -= x
          end



        end


        #params.key?(:role) ? @users = User.all.where(role: params[:role]) : @users = User.all
      end

  elsif !current_user.try(:admin)
    @users = User.all.where(name: current_user.name)
    @tasks = Task.all.where(assigned_to: current_user.name)

end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes params[:user]
    if @user.save
      redirect_to :back, notice: 'User has been successfully updated'
    else
      redirect_to :back, error: "User was unable to be updated"
    end
  end


end
