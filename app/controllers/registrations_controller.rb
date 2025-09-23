class RegistrationsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.admin = false # New registrations are not admins by default

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Welcome to Okie Cup, #{@user.first_name}! Your account has been created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :handicap, :password, :password_confirmation)
  end
end