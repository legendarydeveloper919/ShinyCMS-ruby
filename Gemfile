# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require_relative 'lib/gemfile_plugins_helper'

source 'https://rubygems.org' do
  # Ruby 3.0
  ruby '~> 3.0.0'

  # Rails 6.1
  gem 'rails', '~> 6.1.3'

  # Postgres
  gem 'pg', '~> 1.2.3'

  # Webserver
  gem 'puma', '~> 5.2', groups: %i[ development production ]

  # Load ENV from .env(.*) files
  gem 'dotenv-rails', require: 'dotenv/rails-now'

  # Find out which bits of your code are used more/less in actual use
  gem 'coverband', groups: %i[ development production ]

  # Sessions
  # FIXME: Installing from GitHub because Ruby 3 support is merged but not released:
  # https://github.com/rails/activerecord-session_store/pull/159
  # https://github.com/rails/activerecord-session_store/issues/171
  gem 'activerecord-session_store', git: 'https://github.com/rails/activerecord-session_store'

  # ShinyCMS core plugin
  gem 'shinycms', path: 'plugins/ShinyCMS'

  # ShinyCMS feature plugins
  plugin_names.each do |plugin_name|
    gem_name = underscore( plugin_name )
    gem gem_name, path: "plugins/#{plugin_name}"
  end

  # Email address validation
  gem 'email_address'

  # MJML email rendering
  gem 'mjml-rails'

  # Email previews
  gem 'rails_email_preview'

  # Pagination
  gem 'pagy'

  # Sortable lists
  gem 'acts_as_list'

  # WYSIWYG editor
  gem 'ckeditor'

  # Image storage on S3
  gem 'aws-sdk-s3'
  # Image processing, for resizing etc
  gem 'image_processing', '~> 1.12'
  # Also image processing
  gem 'mini_magick'

  # Tags
  gem 'acts-as-taggable-on'

  # Upvotes (AKA 'Likes') and downvotes
  gem 'acts_as_votable'

  # Generate Atom feeds
  gem 'rss'

  # Email stats
  gem 'ahoy_email'
  # Web stats
  gem 'ahoy_matey'

  # Charts and dashboards
  gem 'blazer'
  # Charts
  gem 'chartkick', '~> 3.4.2'

  # HTML & XML parser
  gem 'nokogiri', '>= 1.11.0.rc4'

  # Better-looking console output
  gem 'amazing_print'

  # Pry is a debugging tool for the Rails console
  if ENV.fetch( 'SHINYCMS_PRY_CONSOLE', 'false' ).downcase == 'true'
    # Set SHINYCMS_PRY_CONSOLE=true in ENV to enable Pry in that environment
    gem 'pry-rails'
  else
    # Otherwise, Pry is enabled by default in dev and test environments
    gem 'pry-rails', groups: %i[ development test ]
  end

  group :production do
    # Airbrake - error monitoring and APM
    # gem 'airbrake'
    # (Commented out because their free trial service is ridiculously restricted,
    # it's mostly buttons that don't work and a sales pitch every time you click
    # on anything. If you're on Heroku I'd recommend trying Coralogix instead,
    # that looks quite nice. And Bugsnag might look a bit clunky in comparison,
    # but it has really well thought-out functionality, especially for teams.)

    # Bugsnag - error monitoring and bug triage
    gem 'bugsnag'

    # Fix request.ip when running behind Cloudflare proxying
    gem 'cloudflare-rails'
  end

  group :development, :test do
    # Tests
    gem 'rspec-rails'

    # Run tests in parallel on multi-core machines
    gem 'parallel_tests'

    # Utils for working with translation strings
    # gem 'i18n-debug'
    gem 'i18n-tasks', '~> 0.9.33'
  end

  group :development do
    # Linter
    gem 'rubocop', require: false
    # Rails-specific linting
    gem 'rubocop-rails', require: false
    # Tests need linting-love too!
    gem 'rubocop-rspec', require: false
    # Performance-related analysis
    gem 'rubocop-performance', require: false

    # Scan for security vulnerabilities
    gem 'brakeman', require: false
    # Check gems for security issues
    gem 'bundler-audit', require: false

    # Best practices
    gem 'rails_best_practices', require: false

    # Ruby Critic generates easy-to-read reports from multiple static analysis tools
    gem 'rubycritic', '~> 4.6.0', require: false

    # Add .analyze method to ActiveRecord objects
    gem 'activerecord-analyze'

    # Capture all emails sent by the system, and view them in a dev webmail inbox
    gem 'letter_opener_web', '~> 1.0'

    # Reload dev server when files change
    gem 'listen', '~> 3.3'

    # Helps you manage your git hooks
    gem 'overcommit', require: false

    # Analysis tools for postgres
    gem 'rails-pg-extras'

    # Used to generate demo site data
    gem 'seed_dump'
  end

  group :test do
    # Wipe the test database before each test run
    gem 'database_cleaner-active_record'

    # Create test objects
    gem 'factory_bot_rails'
    # Fill test objects with fake data
    gem 'faker'

    # Integration tests (request specs)
    gem 'capybara', '>= 2.15'

    # Intercept calls to external services (notably, the Algolia API)
    gem 'webmock'

    # Analyse and report on test coverage via CodeCov
    gem 'codecov', require: false
    # Rspec report formatter for Codecov
    gem 'rspec_junit_formatter'

    # Show test failure details instantly, in-line with progress dots
    gem 'rspec-instafail'
  end
end
