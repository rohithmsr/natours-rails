FactoryBot.define do
  factory :journey do
    association :tour
    start_date { '2023-01-01'.to_date }
    end_date { '2023-01-05'.to_date }
  end
end
