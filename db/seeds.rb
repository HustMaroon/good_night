# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# users
10.times do |i|
  User.create(name: "user_#{i + 1}")
  puts "Created user user_#{i + 1}"
end

User.all.each do |u|
  10.times do
    sleep_time = rand(4..10)
    u.clock_ins.create(
        sleep_time: Time.now - sleep_time.hours,
        wakeup_time: Time.now,
        clocked_in_time: sleep_time,
        created_at: rand((Time.now - 10.days)..Time.now)
    )
  end
  puts "created 10 clock_ins for #{u.name}"
  random_user = rand(1..10)
  user = User.find_by(id: random_user)
  if user && u != user
    u.follow(user)
    puts "#{u.name} followed #{user.name}"
  end
end

