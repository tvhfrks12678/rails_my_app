class QuizzesController < ApplicationController
  MESSAGE_SUCCESS_QUIZ_POST = 'クイズを投稿しました'.freeze
  MESSAGE_FALSE_QUIZ_POST = 'システムエラーが発生しました'.freeze

  def index
    @quizzes = Quiz.all.preload(%i[choices youtube])
  end

  def new
    @quiz_form = Forms::Quizzes::QuizForm.new
  end

  def create
    @quiz_form = Forms::Quizzes::QuizForm.new(quiz_form_params)

    return render 'new' unless @quiz_form.input_valid?

    if @quiz_form.save(current_user)
      flash.now[:success] = MESSAGE_SUCCESS_QUIZ_POST
      return redirect_to quizzes_path
    end

    flash.now[:danger] = MESSAGE_FALSE_QUIZ_POST
    render 'new'
  end

  private

  def quiz_form_params
    params = quiz_params
    params[:choices] = choice_params
    params
  end

  def quiz_params
    params.require(:quiz).permit(:commentary, :youtube_url, :youtube_start_time)
  end

  def choice_params
    params.require(:choices).map { |choice| choice.permit(:content, :rhyme) }
  end
end
