class UsersController < Devise::RegistrationsController

  def dashboard
    @leads = Lead.all.where(lead_owner: current_user.email).to_a
    #Admin will see all tasks, while regular users will only see the tasks assigned to them.
  if current_user.try(:admin)
      @tasks = Task.all.to_a
      @users = User.all
    else
      @users = User.all.where(name: current_user.name)
      @tasks = Task.all.where(assigned_to: current_user.name).to_a
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
