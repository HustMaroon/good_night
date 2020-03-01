class User < ApplicationRecord
  include ActiveModel::Serialization
  has_many :active_relationships, class_name: "Relationship",
           foreign_key: "follower_id",
           dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship",
           foreign_key: "followed_id",
           dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :clock_ins, dependent: :destroy

  has_many :recent_clock_ins, -> {where('clocked_in_time IS NOT NULL AND clock_ins.created_at >= ?', Time.now - 1.week)}, class_name: 'ClockIn'

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end
end
