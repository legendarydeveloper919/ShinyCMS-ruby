# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Seed data for Settings

def set_setting( name:, value: '', description: nil, level: 'site', locked: false )
  setting = Setting.create_or_find_by!( name: name.to_s )
  setting.unlock

  setting.update!( description: description ) if description.present?
  setting.update!( level: level ) unless setting.level == level

  setting_value = setting.values.create_or_find_by!( user: nil )

  setting_value.update!( value: value ) unless Setting.get( name ) == value

  setting.lock if locked
end

set_setting(
  name: :admin_ip_list,
  locked: true,
  description: 'IP addresses allowed to access admin area (comma-separated)'
)

set_setting(
  name: :all_comment_notifications_email,
  locked: true,
  description: 'Set this to an email address to receive a notification for every comment posted on the site'
)

set_setting(
  name: :allowed_to_comment,
  value: 'Anonymous',
  description: 'Lowest-ranking user-type (Anonymous/Pseudonymous/Authenticated/None) that is allowed to post comments'
)

set_setting(
  name: :anon_votes_can_change,
  value: 'false',
  description: 'Anonymous upvotes and downvotes can be changed/removed'
)

set_setting(
  name: :comment_upvotes,
  value: 'true',
  description: 'Allow upvotes on comments'
)

set_setting(
  name: :comment_downvotes,
  value: 'true',
  description: 'Allow downvotes on comments'
)

set_setting(
  name: :default_email,
  value: 'admin@example.com',
  description: 'Default email address to send from'
)

set_setting(
  name: :default_items_per_page,
  value: '10',
  description: 'Default number of items to display per page'
)

set_setting(
  name: :default_items_per_page_in_admin_area,
  value: '10',
  description: 'Default number of items to display per page in the admin area'
)

set_setting(
  name: :post_login_redirect,
  value: '/',
  level: 'admin',
  description: 'Where people are redirected after login, if no referer header'
)

set_setting(
  name: :recaptcha_comment_score,
  value: '0.6',
  level: 'admin',
  locked: true,
  description: 'Minimum score for reCAPTCHA V3 on anon/pseudonymous comments'
)

set_setting(
  name: :recaptcha_registration_score,
  value: '0.4',
  level: 'admin',
  locked: true,
  description: 'Minimum score for reCAPTCHA V3 on user registration'
)

set_setting(
  name: :site_name,
  value: 'MyShinySite',
  description: 'Default email address to send from'
)

set_setting(
  name: :tag_view,
  value: 'cloud',
  level: 'user',
  description: "('cloud' or 'list')"
)

set_setting(
  name: :theme_name,
  value: ''
)

set_setting(
  name: :track_opens,
  value: 'No',
  description: 'Track email opens'
)

set_setting(
  name: :track_opens,
  value: 'No',
  description: 'Track email link-clicks'
)
