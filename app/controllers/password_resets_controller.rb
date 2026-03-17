class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user
      UserMailer.password_reset(user).deliver_now
    end

    redirect_to login_path, notice: "If an account exists with that email, you will receive password reset instructions."
  end

  def edit
    @user = User.find_by_token_for(:password_reset, params[:token])

    unless @user
      redirect_to forgot_password_path, alert: "Invalid or expired password reset link."
    end
  end

  def update
    @user = User.find_by_token_for(:password_reset, params[:token])

    unless @user
      redirect_to forgot_password_path, alert: "Invalid or expired password reset link."
      return
    end

    if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      redirect_to login_path, notice: "Your password has been reset. Please sign in."
    else
      render :edit, status: :unprocessable_entity
    end
  end
end
