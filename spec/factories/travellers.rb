FactoryBot.define do
  factory :traveller do
    first_name { 'Joel' }
    last_name { 'Hicks' }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 6, mix_case: true, special_characters: true) }

    trait :active_traveller do
      status { 'active' }
    end

    trait :inactive_traveller do
      status { 'inactive' }
    end

    trait :with_avatar do
      avatar { Faker::Avatar.image }
    end
  end
end
