FactoryBot.define do
  factory :clock_in do
    user
    sleep_time { Time.current }
    wakeup_time { Time.current }
    clocked_in_time { rand(1..10) }
  end
end
