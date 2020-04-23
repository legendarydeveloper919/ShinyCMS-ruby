# frozen_string_literal: true

# Pundit policy for administration of comments
class Admin::CommentPolicy < Admin::DefaultPolicy
  def index?
    @this_user.can? :list, :spam_comments
  end

  def mark_as_spam?
    @this_user.can? :add, :spam_comments
  end

  def update?
    @this_user.can? :destroy, :spam_comments
  end

  def hide?
    @this_user.can? :hide, :comments
  end

  def unhide?
    @this_user.can? :hide, :comments
  end

  def lock?
    @this_user.can? :lock, :comments
  end

  def unlock?
    @this_user.can? :lock, :comments
  end

  def delete?
    @this_user.can? :destroy, :comments
  end
end
