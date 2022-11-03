# frozen_string_literal: true

class Follow < ApplicationRecord
  extend ActsAsFollower::FollowerLib
  extend ActsAsFollower::FollowScopes

  belongs_to :followable, polymorphic: true
  belongs_to :follower,   polymorphic: true
end
