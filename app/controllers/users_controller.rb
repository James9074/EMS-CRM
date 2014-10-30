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
        @tasks = Task.all.where(assigned_to: params[:username][:name])
        @filtername = params[:username][:name]

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
