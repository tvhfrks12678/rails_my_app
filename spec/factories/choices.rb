FactoryBot.define do
  factory :quiz_choice do
    sequence(:content) { |n| "答え-#{n}" }
    association :quiz
  end
end
