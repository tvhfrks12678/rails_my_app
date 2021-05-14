class AnswerJudgementsController < ApplicationController
  # MSG
  MSG_ANSWER_CORRECT = '正解'.freeze
  MSG_ANSWER_INCORRECT = '不正解'.freeze

  def create
    answers = Answer.get(quiz_id: params[:quiz][:id])

    if Answer.correct?(answers, params[:select_choices])
      flash.now[:success] = MSG_ANSWER_CORRECT
      return redirect_to quizzes_path
    end

    flash.now[:danger] = MSG_ANSWER_INCORRECT
    redirect_to quizzes_path
  end
end
