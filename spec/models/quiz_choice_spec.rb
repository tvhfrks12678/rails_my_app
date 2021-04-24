require 'rails_helper'

RSpec.describe QuizChoice, type: :model do
  it { should belong_to(:quiz) }
  it { should validate_presence_of(:quiz_id) }
  it { should validate_length_of(:content).is_at_most(30) }
end
