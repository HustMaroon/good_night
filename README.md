# Good night apis
```
We would like you to implement a "good night" application to let users track when they go to bed and when they wake up.
We require some restful APIs to achieve the following:

1. Clock In operation, and return all clocked-in times, ordered by created time.
2. Users can follow and unfollow other users.
3. See the sleep records over the past week for their friends, ordered by the length of their sleep.

Please implement the model, DB migrations, and JSON API.
You can assume that there are only two fields on the users: "id" and "name”.
You do not need to implement any user registration API.
You can use any gems you like.
```

## Approach:
The application should be developed based on user's 6 actions:
- Sleep: track user's sleep time
- Wakeup: track user's wakeup time
- Sleep times: list all user's tracked sleep and wakeup time
- Follow: user can follow other users
- Unfollow: user can unfollow other users
- Friends' sleep times: user can see the latest sleep time data of their friends

According to the analysis above, the application will need the models below:
* user:
  * name: String
* clock_in:
  * sleep_time: DateTime
  * wakeup_time: DateTime
  * clocked_in_time: Float # the duration of user's sleep in hour
* relationship:
  * follower_id: Integer
  * followed_id: Integer
## Concerns
* Idealy, the api flow will be invoked like: sleep - wakeup - sleep - wakeup, then the clock_in will be recorded based on each sleep - wakeup pair, sequently. However, due to some unknown reasons, there will be scenarios that the flow becomes abnormally:
  * sleep - sleep - wakeup: then the first clock_in record made by the first sleep action will be marked as incompleted, defaultly, the listing methods will skips these records
  * sleep - wakeup - wakeup: similarly, sending the wakeup action without a corresponding sleep action will fire an error.
* Authentication and authorization:

  `You can assume that there are only two fields on the users: "id" and "name”.`
  
   => since user model has only 2 fields: id and name, I assume that the authentication and authorization features are not required in this implementation

## Setup and run with sample data:
* Prerequisite: environment that has rails installed
* Setup the application following these steps:
  * run `bundle install` to install required gems
  * run `rails db:seed` to generate sample data
  * run `rails sever` to start the sever
* Use an API testing tool like Postman and try these api endpoints:
  * /api/v1/sleep
    * method: POST
    * params: { user_id: 1 }
  * /api/v1/wakeup
    * method: POST
    * params: { user_id: 1 }
  * /api/v1/clocked_in_times
    * method: GET
    * params: { user_id: 1 }
  * /api/v1/friends_sleep_time
    * method: GET
    * params: { user_id: 1 }
  * /api/v1/follow
    * method: POST
    * params: { follower_id: 1, followed_id: 2 }
  * /api/v1/unfollow
    * method: POST
    * params: { follower_id: 1, followed_id: 2 }
  
