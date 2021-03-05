# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_email_preview'

RailsEmailPreview.setup do |config|
  # Controller that RailsEmailPreview::ApplicationController inherits from
  config.parent_controller = 'ShinyCMS::Admin::Tools::RailsEmailPreviewBaseController'

  # Show/hide 'Send Email' button
  config.enable_send_email = true

  # Hook before rendering preview:
  # config.before_render do |message, preview_class_name, mailer_action|
  #   # Use roadie-rails:
  #   Roadie::Rails::MailInliner.new(message, message.roadie_options).execute
  #   # Use premailer-rails:
  #   Premailer::Rails::Hook.delivering_email(message)
  #   # Use actionmailer-inline-css:
  #   ActionMailer::InlineCssHook.delivering_email(message)
  # end
end

Rails.application.config.to_prepare do
  RailsEmailPreview.layout = 'shinycms/admin/layouts/admin_area'

  # RailsEmailPreview.locale = :de

  # Auto-load preview classes from:
  RailsEmailPreview.preview_classes = RailsEmailPreview.find_preview_classes 'plugins/ShinyCMS/app/mailer_previews'
end
