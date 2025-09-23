class ProfileController < ApplicationController
  before_action :require_authentication

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def password
    @user = current_user
  end

  def update_password
    @user = current_user

    if @user.authenticate(params[:current_password])
      if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        redirect_to profile_path, notice: "Password updated successfully!"
      else
        render :password, status: :unprocessable_entity
      end
    else
      @user.errors.add(:current_password, "is incorrect")
      render :password, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:first_name, :last_name, :email, :handicap, :avatar)
  end

  def require_authentication
    redirect_to login_path unless current_user
  end
end
