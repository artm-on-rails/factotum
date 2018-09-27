FactoryBot.define do
  factory :trade do
    sequence(:name) { |n| "Trade #{n}"}

    factory :tailor do
      name { "Tailor" }
    end

    factory :reaper do
      name { "Reaper" }
    end

    factory :pipe_player do
      name { "Pipe player" }
    end
  end
end
