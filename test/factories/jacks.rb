FactoryBot.define do
  factory :jack do
    sequence(:email) { |n| "jack_of_#{n}@trades.com"}
    password { SecureRandom.uuid }

    trait :of_all_trades do
      sequence(:email) { |n| "johannes.factotum_#{n}@trades.com"}
    end
  end
end
