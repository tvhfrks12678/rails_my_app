class UsersController < ApplicationController
  MSG_SIGNUP_SUCCESS = '韻クイズへようこそ!'.freeze

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
    flash[:success] = MSG_SIGNUP_SUCCESS
    redirect_to @user
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
