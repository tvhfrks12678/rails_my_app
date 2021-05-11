class QuizzesController < ApplicationController
  def index
    @quizzes = Quiz.all.includes(:choices)
  end

  def new
    @quiz = Quiz.new
  end

  def create
    save_quiz(quiz_params)
    rhyme_list = get_save_rhyme_list(rhyme_params)
    save_choice(choice_params, rhyme_list)
  end

  def save_quiz(quiz_params)
    @quiz = current_user.quizzes.build(quiz_params)
    @quiz.save
  end

  def get_save_rhyme_list(rhyme_params)
    rhyme_list = []
    rhyme_params.each do |rhyme_param|
      rhyme = Rhyme.find_or_create_by(rhyme_param)
      rhyme_list << rhyme unless rhyme.id.nil?
    end
    rhyme_list
  end

  def save_choice(choice_params, rhyme_list)
    choice_params.each_with_index do |choice_param, idx|
      next if choice_param[:content].empty?

      choice_rhyme = get_rhyme(idx, rhyme_list)

      choice = @quiz.choices.build(content: choice_param[:content], rhyme_id: choice_rhyme.id)
      choice.save
    end
  end

  def get_rhyme(idx, rhyme_list)
    rhyme_content = Rhyme.new
    params[:answer][:"rhyme_0#{idx}"].each_with_index do |rhyme, rhyme_idx|
      if rhyme[:check].present?
        rhyme_content = rhyme_list[rhyme_idx]
        break
      end
    end
    rhyme_content
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
  end
end
