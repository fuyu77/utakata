# frozen_string_literal: true

module ActsAsFollower::Follower::InstanceMethods
  def follow(followable)
    return if self == followable

    params = if parent_class_name(followable) == 'User'
               {
                 followable_id: followable.id,
                 followable_type: parent_class_name(followable),
                 user_id: followable.id
               }
             else
               {
                 followable_id: followable.id,
                 followable_type: parent_class_name(followable),
                 user_id: followable.user_id
               }
             end
    follows.where(params).first_or_create!
  end
end
