class QuizzesController < ApplicationController
  MESSAGE_SUCCESS_QUIZ_POST = 'クイズを投稿しました'.freeze
  QUIZ_CHOICE_MIN = 3

  def index
    @quizzes = Quiz.all.includes(:choices)
  end

  def new
    init_form

    QUIZ_CHOICE_MIN.times do
      choice = @quiz.choices.build
      choice.id = SecureRandom.uuid
      @choices << choice
    end

    @select_box_choice_rhyme = Rhyme.get_select_box_choice_rhyme(@rhymes)

    rhyme = Rhyme.new
    rhyme.id = SecureRandom.uuid
    @rhymes << rhyme
  end

  def init_form
    @quiz = Quiz.new
    @choices = []
    @rhymes = []

    # 選択肢の入力欄の母音のSelectBoxに設定されている値の配列
    @choice_rhymes = []

    # 選択肢の入力欄の母音のSelectBoxの中身
    @select_box_choice_rhyme = []
  end

  def create
    init_form

    ActiveRecord::Base.transaction do
      unless save_input_quiz?
        process_quiz_input_error
        raise ActiveRecord::Rollback
      end
      flash[:success] = MESSAGE_SUCCESS_QUIZ_POST
      redirect_to quizzes_path
    end
  end

  # クイズ情報に入力エラーがあった場合に行う処理
  def process_quiz_input_error
    @select_box_choice_rhyme = Rhyme.get_select_box_choice_rhyme(@rhymes)
    @choice_rhymes = choice_params.pluck(:rhyme)
    render 'new'
  end

  # 入力されたクイズ情報が保存できるか判定する
  #
  # @return [Boolean] true:入力エラーがない, false:入力エラーがある
  def save_input_quiz?
    is_saved_quiz = save_quiz?(quiz_params)
    is_saved_rhyme = save_rhyme?(rhyme_params)

    rhyme_ids_by_rhyme_content = Rhyme.get_rhyme_ids_by_rhyme_content(@rhymes)

    is_saved_choice = save_choice?(choice_params, rhyme_ids_by_rhyme_content)
    is_saved_quiz && is_saved_rhyme && is_saved_choice
  end

  # クイズを保存できるか判定する
  #
  # @param [ActionController::Parameters] quiz_params クイズの入力された値
  # @return [Boolean] true:入力エラーがない, false:入力エラーがある
  def save_quiz?(quiz_params)
    @quiz = current_user.quizzes.build(quiz_params)
    @quiz.save
  end

  # 母音を保存できるか判定する
  #
  # @param [ActionController::Parameters] rhyme_params 母音の入力欄の値
  # @return [Boolean] true:入力エラーがない, false:入力エラーがある
  def save_rhyme?(rhyme_params)
    is_saved = true
    rhyme_params.each do |rhyme_param|
      rhyme = Rhyme.find_or_initialize_by(rhyme_param)

      if rhyme.new_record? && !rhyme.save
        rhyme.id = SecureRandom.random_number(64 << 64)
        is_saved = false
      end

      @rhymes << rhyme
    end
    is_saved
  end

  # 選択肢を保存できるか判定する
  #
  # @param [ActionController::Parameters] rhyme_params 選択肢の入力欄の値
  # @return [Boolean] true:入力エラーがない, false:入力エラーがある
  def save_choice?(choice_params, rhyme_ids_by_rhyme_content)
    is_saved = true
    choice_params.each do |choice_param|
      choice = get_choice_by(choice_param, rhyme_ids_by_rhyme_content)

      unless choice.save
        choice.id = SecureRandom.random_number(64 << 64)
        is_saved = false
      end

      @choices << choice
    end

    is_saved
  end

  # Choiceクラスを取得する
  #
  # @param [ActionController::Parameters] choice_param 選択肢の入力欄の値
  # @param [Hash] rhyme_ids_by_rhyme_content 母音と母音のidの組み合わせ
  # @return [Choice]
  def get_choice_by(choice_param, rhyme_ids_by_rhyme_content)
    choice_rhyme_id = rhyme_ids_by_rhyme_content[choice_param[:rhyme].to_sym]
    @quiz.choices.build(content: choice_param[:content], rhyme_id: choice_rhyme_id)
  end

  private

  def quiz_params
    params.require(:quiz).permit(:commentary)
  end

  def choice_params
    params.require(:choice).map { |choice| choice.permit(:content, :rhyme) }
  end

  def rhyme_params
    params.require(:rhyme).map do |rhyme|
      rhyme.permit(:content)
    end
  end
end
