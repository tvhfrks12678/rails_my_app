class AnswersController < ApplicationController
  def create
    @answer = ViewModels::Answers::Answer.new(quiz_id: params[:quiz][:id], select_choice_ids: params[:select_choices])
  end
end
