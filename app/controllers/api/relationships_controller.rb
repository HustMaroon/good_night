# frozen_string_literal: true
module Api
  class RelationshipsController < ApplicationController
    include Response
    include ExceptionHandler
    before_action :set_user

    def follow
      if @follower.following?(@followed)
        return json_response(
            { error_message: I18n.t('errors.relationship_already_exists') },
            :unprocessable_entity)
      end
      @follower.follow(@followed)
      json_response(nil, :no_content)
    end

    def unfollow
      unless @follower.following?(@followed)
        return json_response(
            { error_message: I18n.t('errors.relationship_not_found') },
            :unprocessable_entity)
      end
      @follower.unfollow(@followed)
    end

    private
    def set_user
      @follower = User.find(params[:follower_id])
      @followed = User.find(params[:followed_id])
    end
  end
end