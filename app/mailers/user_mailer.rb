# frozen_string_literal: true

# Mailer for user account related emails (password reset, etc) (uses Devise)
class UserMailer < ApplicationMailer
  include Devise::Controllers::UrlHelpers

  default from: ->(*) { default_email }
  default template_path: 'user_mailer'

  def confirmation_instructions( user, token )
    @resource = @user = user
    @token = token

    mail to: user.email, subject: t( '.subject' ) do |format|
      format.html
      format.text
    end
  end

  def reset_password( user, token )
    @resource = @user = user
    @token = token

    mail to: user.email, subject: t( '.subject' ) do |format|
      format.html
      format.text
    end
  end

  def password_changed( user )
    @resource = @user = user

    mail to: user.email, subject: t( '.subject' ) do |format|
      format.html
      format.text
    end
  end

  def email_changed( user )
    @resource = @user = user

    mail to: user.email, subject: t( '.subject' ) do |format|
      format.html
      format.text
    end
  end

  def unlock_instructions( user, token )
    @resource = @user = user
    @token = token

    mail to: user.email, subject: t( '.subject' ) do |format|
      format.html
      format.text
    end
  end
end
