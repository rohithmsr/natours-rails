FactoryBot.define do
  factory :journey do
    association :tour
    start_date { '2023-01-01'.to_date }
    end_date { '2023-01-05'.to_date }

    trait :with_travellers do
      transient do
        travellers { [create(:traveller)] }
      end

      after :create do |journey, context|
        journey.travellers << context.travellers
      end
    end
  end
end
