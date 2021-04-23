class SessionsController < ApplicationController
  MSG_LOG_IN_FAILURE = 'EmaiまたはPasswordが正しくありません。'.freeze

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      return redirect_to user
    end

    flash.now[:danger] = MSG_LOG_IN_FAILURE
    render 'new'
  end

  def destroy
  end
end
