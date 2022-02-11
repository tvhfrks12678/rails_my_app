class UsersController < ApplicationController
  MSG_AFTER_SIGNUP_SUCCESS = 'へようこそ!'.freeze

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    return render 'new' unless @user.save

    log_in @user
    msg_signup_success = "#{Constants::SITE_TITLE}#{MSG_AFTER_SIGNUP_SUCCESS}"
    flash[:success] = msg_signup_success
    redirect_to @user
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
