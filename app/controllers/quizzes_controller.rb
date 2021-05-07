class QuizzesController < ApplicationController
  def index
    @quizzes = Quiz.all.includes(:choices)
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = current_user.quizzes.build(quiz_params)
    @quiz.save

    choice_params.each do |choice_param|
      choice = @quiz.choices.build(choice_param)
      choice.save
    end

    rhyme_params.each do |rhyme_param|
      rhyme = Rhyme.create(rhyme_param)
      rhyme.save
    end
  end

  private

  def quiz_params
    params.require(:quiz).permit(:commentary)
  end

  def choice_params
    params.require(:choice).map { |choice| choice.permit(:content) }
  end

  def rhyme_params
    params.require(:rhyme).map do |rhyme|
      rhyme.permit(:content)
    end
    # params.permit(rhyme: [:content])
  end
end
