class AnswerJudgementsController < ApplicationController
  MSG_ANSWER_CORRECT = '正解'.freeze
  MSG_ANSWER_INCORRECT = '不正解'.freeze

  def create
    answer_combinations = get_answer_combinations(params[:quiz][:id])
    if answer_correct?(params[:select_choices], answer_combinations)
      flash.now[:success] = MSG_ANSWER_CORRECT
      return
    end

    flash.now[:danger] = MSG_ANSWER_INCORRECT
  end

  def get_answer_combinations(quiz_id)
    choices = Choice.where(quiz_id: quiz_id).where.not(rhyme_id: nil).select(:id, :rhyme_id)
    rhyme_ids = choices.map(&:rhyme_id).uniq
    answer_combinations = []

    rhyme_ids.each do |rhyme_id|
      answer_combinations << choices.select { |choice| choice.rhyme_id == rhyme_id }.map { |item| item.id.to_s }
    end
    answer_combinations
  end

  def answer_correct?(select_choices, answer_combinations)
    answer_combinations.each do |answer_combination|
      return true if (select_choices - answer_combination).empty?
    end
    false
  end
end
