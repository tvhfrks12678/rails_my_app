class ApplicationController < ActionController::Base
  def hello 
    render json: 'test'
  end
end
