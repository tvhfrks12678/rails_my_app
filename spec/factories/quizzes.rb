FactoryBot.define do
  factory :quiz do
    sequence(:commentary) { |n| "解説-#{n}" }
    association :user
  end
end
