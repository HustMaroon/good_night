# frozen_string_literal: true
module Api
  class ClockInsController < ApplicationController
    include Response
    include ExceptionHandler
    before_action :set_user
    def sleep
      @clock_in = ClockIn.create!(user: @user, sleep_time: Time.now)
      json_response(@clock_in, :created)
    end

    def wake_up
      @clock_in = ClockIn.find_by(user: @user, wakeup_time: nil)
      unless @clock_in
        return json_response(
            {error_message: I18n.t('errors.corresponding_sleep_time_not_recorded')},
            :not_found)
      end
      wakeup_time = Time.now
      clocked_in_time = ((Time.now - @clock_in.sleep_time) / 3600).round(2) # convert to hour
      # since there is no other trigger that change sleep_time and wakeup_time
      # it's better to directly calculate clocked_in_time than to use callback
      @clock_in.update(wakeup_time: wakeup_time, clocked_in_time: clocked_in_time)
      json_response(@clock_in, :accepted)
    end

    def clocked_in_times
      @clock_ins = @user.clock_ins
      json = @clock_ins.as_json
      json_response(json)
    end

    def friends_sleep_time
      @friends = @user.following.includes(:recent_clock_ins)
      @friends.sort_by { |f| f.recent_clock_ins.sum(:clocked_in_time)  }.reverse
      json = @friends.as_json(only: [:id, :name], include: :recent_clock_ins)
      json_response(json)
    end

    private
    def set_user
      @user = User.find(params[:user_id])
    end
  end
end