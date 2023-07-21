FactoryBot.define do
  factory :tour do
    name { 'The Land II Voyager' }
    key { 'the_land_ii_voyager' }
    rating { 3.5 }
    duration { 5 }
    difficulty { 'medium' }
    price { 1000 }

    trait :easier_tour do
      difficulty { 'easy' }
    end

    trait :harder_tour do
      difficulty { 'medium' }
    end

    trait :tour_with_description do
      description { Faker::Lorem.paragraph(sentence_count: 6) }
    end
  end
end
