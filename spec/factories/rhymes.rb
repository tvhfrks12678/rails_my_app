FactoryBot.define do
  factory :rhyme do
    sequence(:content) { |n| "韻-#{n}" }
  end
end
