# frozen_string_literal: true

# Model class for discussions (used to group comments)
class Discussion < ApplicationRecord
  belongs_to :resource, inverse_of: :discussion, polymorphic: true

  has_many :all_comments, class_name: 'Comment',
                          foreign_key: :discussion_id,
                          inverse_of: :discussion,
                          dependent: :destroy

  # Instance methods

  def comments
    all_comments.where( spam: false )
  end

  def notifiable?
    resource&.user&.email.present?
  end

  def notification_email
    return unless notifiable?

    resource.user.email
  end

  def top_level_comments
    comments.where( parent: nil ).order( :number )
  end

  def lock
    update( locked: true )
  end

  def unlock
    update( locked: false )
  end

  def hide
    update( hidden: true )
  end

  def unhide
    update( hidden: false )
  end
end
