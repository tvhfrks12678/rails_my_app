class QuizzesController < ApplicationController
  def index
    @quizzes = Quiz.all.includes(:choices)
  end

  def new
    @quiz = Quiz.new
  end

  def create
    save_quiz(quiz_params)
    rhyme_ids_by_rhyme_content = get_rhyme_ids_by_rhyme_content_and_save_rhyme(rhyme_params)
    save_choice(choice_params, rhyme_ids_by_rhyme_content)
  end

  def save_quiz(quiz_params)
    @quiz = current_user.quizzes.build(quiz_params)
    @quiz.save
  end

  def get_rhyme_ids_by_rhyme_content_and_save_rhyme(rhyme_params)
    rhyme_ids_by_rhyme_content = {}
    rhyme_params.each do |rhyme_param|
      next if rhyme_param.empty?

      rhyme = Rhyme.find_or_create_by(rhyme_param)
      rhyme_ids_by_rhyme_content[rhyme_param[:content].to_sym] = rhyme.id
    end
    rhyme_ids_by_rhyme_content
  end

  def save_choice(choice_params, rhyme_ids_by_rhyme_content)
    choice_params.each do |choice_param|
      next if choice_param[:content].empty?

      choice_rhyme_id = choice_param[:rhyme].empty? ? nil : rhyme_ids_by_rhyme_content[choice_param[:rhyme].to_sym]

      choice = @quiz.choices.build(content: choice_param[:content], rhyme_id: choice_rhyme_id)
      choice.save
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
