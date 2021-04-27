FactoryBot.define do
  factory :choice do
    sequence(:content) { |n| "答え-#{n}" }
    association :quiz
  end
end
