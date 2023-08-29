# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
# rails db:setup

def generate_slug(name)
  ActiveSupport::Inflector.parameterize(name, separator: '_')
end

def generate_tour_name
  mountain = Faker::Mountain.name
  job = Faker::Cosmere.feruchemist

  job = case job
        when "Bloodmaker" then "Hiker"
        when "Trueself" then "Explorer"
        else job
        end

  "#{mountain} #{job}"
end

# TOURS
(1..30).each do |id|
  tour = Tour.new(
    name: generate_tour_name,
    rating: rand(1.0..5.0).round(2),
    duration: rand(1..14),
    difficulty: %w[easy medium hard].sample,
    price: rand(1000..10000),
    price_discount: [0, 0, 0, 0, 0, 10, 20, 25].sample,
    description: Faker::Lorem.paragraph(sentence_count: 6),
    key: "TO-BE-GENERATED"
  )
  tour.key = generate_slug(tour.name)
  tour.save!
end

# TRAVELLERS
(1..5).each do |id|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name

  Traveller.create!(
    first_name: first_name,
    last_name: last_name,
    email: Faker::Internet.email(name: "#{first_name} #{last_name}", separators: ['.']),
    avatar: Faker::Avatar.image(size: "300x300"),
    password: "tester1",
    password_confirmation: "tester1"
  )
end

# JOURNEYS
(1..10).each do |id|
  start_date = DateTime.now - rand(0..10)
  end_date = start_date + rand(0..20)

  Journey.create!(
    start_date: start_date,
    end_date: end_date,
    tour_id: Tour.find(Tour.ids.sample).id
  )
end

# TRAVEL_ASSIGNMENTS
(1..10).each do |id|
  TravelAssignment.create!(traveller_id: Traveller.ids.sample, journey_id: Journey.ids.sample)
end
