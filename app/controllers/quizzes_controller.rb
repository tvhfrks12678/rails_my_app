class QuizzesController < ApplicationController
  def index
    @quizzes = Quiz.all.includes(:choices)
  end
end
