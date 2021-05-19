class AnswersController < ApplicationController
  def create
    @answer = Answer.get(quiz_id: params[:quiz][:id], select_choice_ids: params[:select_choices])
    # respond_to do |format|
    #   format.html { redirect_to quizzes_path }
    #   format.js
    # end
  end
end
