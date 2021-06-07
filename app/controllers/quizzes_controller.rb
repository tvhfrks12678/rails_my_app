class QuizzesController < ApplicationController
  MESSAGE_SUCCESS_QUIZ_POST = 'クイズを投稿しました'.freeze
  QUIZ_CHOICE_MIN = 3

  SELECT_BOX_DEFAULT_NAME = '韻なし'.freeze
  SELECT_BOX_DEFAULT_ID = ''.freeze

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

    rhyme = Rhyme.new
    rhyme.id = SecureRandom.uuid
    @rhymes << rhyme
  end

  def init_form
    @quiz = Quiz.new
    @choices = []
    @rhymes = []
    @choice_rhymes = []
    @select_box_choice_rhyme = [{ id: SELECT_BOX_DEFAULT_ID, name: SELECT_BOX_DEFAULT_NAME }]
  end

  def create
    init_form

    ActiveRecord::Base.transaction do
      isSavedQuiz = save_quiz?(quiz_params) && save_rhyme?(rhyme_params)
      rhyme_ids_by_rhyme_content = get_rhyme_ids_by_rhyme_content
      isSavedChoice = save_choice?(choice_params, rhyme_ids_by_rhyme_content)
      isSavedQuiz &&= isSavedChoice
      raise NotFoundException unless isSavedQuiz
    end
    flash[:success] = MESSAGE_SUCCESS_QUIZ_POST
    redirect_to quizzes_path
  rescue StandardError => e
    render 'new'
  end

  # TODO: 母音の入力チェックを実装する
  # @quiz.errors.add(:choice_rhyme, '母音は２つ以上選択して下さい') unless @quiz.save

  def save_quiz?(quiz_params)
    @quiz = current_user.quizzes.build(quiz_params)
    @quiz.save
  end

  def save_rhyme?(rhyme_params)
    is_saved = true
    rhyme_params.each do |rhyme_param|
      if rhyme_param[:content].empty?
        rhyme = Rhyme.new(id: SecureRandom.random_number(64 << 64))
        @rhymes << rhyme
        next
      end

      rhyme = Rhyme.find_or_initialize_by(rhyme_param)

      if rhyme.new_record? && !rhyme.save
        rhyme.id = SecureRandom.random_number(64 << 64)
        is_saved = false
      end

      @rhymes << rhyme
    end
    is_saved
  end

  def get_rhyme_ids_by_rhyme_content
    rhyme_ids_by_rhyme_content = {}
    @rhymes.each do |rhyme|
      next if rhyme.content.nil?

      rhyme_ids_by_rhyme_content[rhyme.content.to_sym] = rhyme.id

      @select_box_choice_rhyme << { id: rhyme.content, name: rhyme.content }
    end
    rhyme_ids_by_rhyme_content
  end

  def save_choice?(choice_params, rhyme_ids_by_rhyme_content)
    is_saved = true
    choice_params.each do |choice_param|
      @choice_rhymes << choice_param[:rhyme]

      if choice_param[:content].empty?
        choice = Choice.new(id: SecureRandom.random_number(64 << 64))
        @choices << choice
        next

      end
      choice_rhyme_id = choice_param[:rhyme].empty? ? nil : rhyme_ids_by_rhyme_content[choice_param[:rhyme].to_sym]

      choice = @quiz.choices.build(content: choice_param[:content], rhyme_id: choice_rhyme_id)
      is_saved = false unless choice.save
      @choices << choice
    end

    is_saved
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
