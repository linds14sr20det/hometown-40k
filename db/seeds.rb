# Create some users These shouldn't change after initial deploy

if User.count == 0
  admin = User.new(
      email:  "hometown40k@gmail.com",
      name: "Ward Kapach",
      password: 'password',
      password_confirmation: 'password',
      # #confirmation_token: true,
      # confirmation_sent_at: Time.zone.now,
      # confirmed_at: Time.zone.now
  )
  admin.skip_confirmation!
  admin.save!

  admin = User.new(
      email:  "stephen.r.lind@gmail.com",
      name: "Stephen Lind",
      password: 'password',
      password_confirmation: 'password',
      # #confirmation_token: true,
      # confirmation_sent_at: Time.zone.now,
      # confirmed_at: Time.zone.now
  )
  admin.skip_confirmation!
  admin.save!
end

# Create a bunch of test accounts

# 99.times do |n|
#   name  = Faker::Name.name
#   email = "example-#{n+1}@railstutorial.org"
#   password = "password"
#   User.create!(name:  name,
#                email: email,
#                password:              password,
#                password_confirmation: password,
#                activated: true,
#                activated_at: Time.zone.now)
# end
#
# users = User.order(:created_at).take(6)

#Create seed cohort, seed system, and 40 seed registrants
if Rails.env == "development"
  event = Cohort.create!(
    start_at: Time.zone.now,
    end_at: Time.zone.now + 1.year,
    descriptive_date: "immediately",
    active: true
  )

  game = System.create!(
    title: 'Test Game',
    descriptive_date: 'right now',
    description: 'this is a test game',
    max_players: 40,
    cost: 30,
    cohort: event,
    start_date: Time.zone.now
  )

  40.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    Registrant.create!(
      name: name,
      email: email,
      paid: true,
      system: game
    )
  end

end
