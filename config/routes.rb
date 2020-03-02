Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post '/sleep' => 'clock_ins#sleep'
      post '/wake_up' => 'clock_ins#wake_up'
      get '/clocked_in_times' => 'clock_ins#clocked_in_times'
      get '/friends_sleep_time' => 'clock_ins#friends_sleep_time'
      post '/follow' => 'relationships#follow'
      post '/unfollow' => 'relationships#unfollow'
    end
  end
end
