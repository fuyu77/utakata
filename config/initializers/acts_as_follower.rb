# frozen_string_literal: true

module ActsAsFollower #:nodoc:
  module Follower
    module InstanceMethods
      def follow(followable)
        if self != followable
          if parent_class_name(followable) == 'User'
            params = { followable_id: followable.id, followable_type: parent_class_name(followable), user_id: followable.id }
          else
            params = { followable_id: followable.id, followable_type: parent_class_name(followable), user_id: User.find(followable.user_id).id }
          end
          follows.where(params).first_or_create!
        end
      end
    end
  end
end
