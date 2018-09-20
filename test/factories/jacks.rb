FactoryBot.define do
  factory :jack do
    sequence(:email) { |n| "jack_of_#{n}@trades.com"}
  end
end
