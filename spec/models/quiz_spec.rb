require 'rails_helper'

RSpec.describe Quiz, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:choices).dependent(:destroy) }
  it { should validate_presence_of(:user_id) }
  it { should validate_length_of(:commentary).is_at_most(255) }

  it 'is expected that order => created_at desc' do
    10.times do
      create(:quiz)
    end
    latest_quiz = create(:quiz)
    expect(latest_quiz).to eq Quiz.first
  end
end
