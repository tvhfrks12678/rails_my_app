class QuizInput
  attr_accessor :quiz, :choices, :rhymes, :choice_rhymes, :select_box_choice_rhyme

  QUIZ_CHOICE_MIN = 3

  # @param [Quiz] quiz
  # @param @choices [Array<Choice>] choices
  # @param [Array<Rhyme>] rhymes
  # @param @choice_rhymes [Array] choice_rhymes 選択肢の入力欄の母音のSelectBoxに設定されている値の配列
  # @param @select_box_choice_rhyme [Array<Hash>] select_box_choice_rhyme 選択肢の入力欄の母音のSelectBoxの中身
  def initialize
    @quiz = Quiz.new
    @choices = []
    @rhymes = []
    @choice_rhymes = []
    @select_box_choice_rhyme = []
  end

  def init
    @choices = set_init_choices
    @rhymes = set_init_rhyme
    @select_box_choice_rhyme = Rhyme.get_select_box_choice_rhyme(@rhymes)
    self
  end

  private

  def set_init_rhyme
    rhyme = Rhyme.new
    rhyme.id = randam_id
    rhymes = []
    rhymes << rhyme
  end

  def set_init_choices
    QUIZ_CHOICE_MIN.times.map { @quiz.choices.build(id: randam_id) }
  end

  def randam_id
    SecureRandom.uuid
  end
end
