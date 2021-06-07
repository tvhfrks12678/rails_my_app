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
    @choice_rhymes = ['']
    @select_box_choice_rhyme = [{ id: SELECT_BOX_DEFAULT_ID, name: SELECT_BOX_DEFAULT_NAME }]
  end

  def create
    init_form

    save_quiz(quiz_params)
    rhyme_ids_by_rhyme_content = get_rhyme_ids_by_rhyme_content_and_save_rhyme(rhyme_params)
    save_choice(choice_params, rhyme_ids_by_rhyme_content)

    render 'new'
    # flash[:success] = MESSAGE_SUCCESS_QUIZ_POST
    # redirect_to current_user
  end

  def save_quiz(quiz_params)
    @quiz = current_user.quizzes.build(quiz_params)

    # @quiz.errors.add(:choice_rhyme, '母音は２つ以上選択して下さい') unless @quiz.save

    # return render 'new' unless @quiz.save
  end

  def get_rhyme_ids_by_rhyme_content_and_save_rhyme(rhyme_params)
    rhyme_ids_by_rhyme_content = {}

    # @rhymes = []
    # @select_box_choice_rhyme = [{ id: SELECT_BOX_DEFAULT_ID, name: SELECT_BOX_DEFAULT_NAME }]
    rhyme_params.each do |rhyme_param|
      if rhyme_param[:content].empty?
        rhyme = Rhyme.new
        rhyme.id = SecureRandom.uuid
        @rhymes << rhyme
        next
      end

      rhyme = Rhyme.find_or_initialize_by(rhyme_param)

      rhyme.id = SecureRandom.uuid if rhyme.new_record? && rhyme.save

      @rhymes << rhyme

      rhyme_ids_by_rhyme_content[rhyme_param[:content].to_sym] = rhyme.id

      @select_box_choice_rhyme << { id: rhyme_param[:content], name: rhyme_param[:content] }
    end
    rhyme_ids_by_rhyme_content
  end

  def save_choice(choice_params, rhyme_ids_by_rhyme_content)
    # @choices = []
    # @choice_rhymes = []
    choice_params.each do |choice_param|
      @choice_rhymes << choice_param[:rhyme]

      if choice_param[:content].empty?
        choice = Choice.new
        choice.id = SecureRandom.uuid
        @choices << choice
        next

      end

      choice_rhyme_id = choice_param[:rhyme].empty? ? nil : rhyme_ids_by_rhyme_content[choice_param[:rhyme].to_sym]

      choice = @quiz.choices.build(content: choice_param[:content], rhyme_id: choice_rhyme_id)
      choice.save

      @choices << choice
      # return render 'new' unless choice.save
    end
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
