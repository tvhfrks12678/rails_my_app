# frozen_string_literal: true

class QuizzesController < ApplicationController
  MESSAGE_SUCCESS_QUIZ_POST = 'クイズを投稿しました'
  MESSAGE_FALSE_QUIZ_POST = 'システムエラーが発生しました'

  def index
    @quizzes = Quiz.all.preload(%i[choices youtube])
  end

  def edit_index
    @quiz_edits = ViewModels::Quizzes::QuizEditIndexViewModel.get_list(current_user)
  end

  def new
    @quiz_form = Forms::Quizzes::QuizForm.new
  end

  def create
    @quiz_form = Forms::Quizzes::QuizForm.new(quiz_form_params)

    save_quiz_form
  end

  def edit
    quiz = quiz_to_edit
    @quiz_form = Forms::Quizzes::QuizForm.new(quiz: quiz)
    render 'new'
  end

  def update
    quiz = quiz_to_edit
    @quiz_form = Forms::Quizzes::QuizForm.new(quiz_form_params, quiz: quiz)

    save_quiz_form
  end

  private

  def quiz_to_edit
    Quiz.find(params[:id])
  end

  def save_quiz_form
    return render 'new' unless @quiz_form.input_valid?

    if @quiz_form.save(current_user)
      flash.now[:success] = MESSAGE_SUCCESS_QUIZ_POST
      return redirect_to quizzes_path
    end

    flash.now[:danger] = MESSAGE_FALSE_QUIZ_POST
    render 'new'
  end

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
