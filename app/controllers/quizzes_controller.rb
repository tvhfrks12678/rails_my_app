# frozen_string_literal: true

class QuizzesController < ApplicationController
  MESSAGE_SUCCESS_QUIZ_POST = 'クイズを投稿しました'
  MESSAGE_FALSE_QUIZ_POST = 'システムエラーが発生しました'
  MESSAGE_SUCCESS_QUIZ_DELETE = '削除しました'

  def index
    @quizzes = Quiz.all.preload(%i[choices youtube])
  end

  def edit_index
    @quiz_posts_search_form = Forms::Quizzes::QuizSearchForEditIndexForm.new
    @quiz_edits = @quiz_posts_search_form.search(current_user)
  end

  def edit_index_search
    @quiz_posts_search_form = Forms::Quizzes::QuizSearchForEditIndexForm.new(quiz_posts_search_params)
    @quiz_edits = @quiz_posts_search_form.search(current_user)

    render 'edit_index'
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

  def destroy
    quiz = quiz_to_edit
    quiz.destroy
    flash.now[:success] = MESSAGE_SUCCESS_QUIZ_DELETE
    redirect_to action: 'edit_index'
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

  def quiz_posts_search_params
    params.require(:forms_quizzes_quiz_search_for_edit_index_form).permit(:search_word, :from_rhyme_characters,
                                                                          :to_rhyme_characters, :from_date, :to_date)
  end
end
