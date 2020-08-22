# frozen_string_literal: true

# ============================================================================
# Project:   ShinyPages plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyPages/lib/shiny_pages/engine.rb
# Purpose:   Rails::Engine config
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

module ShinyPages
  # Loads Rails::Engine features
  class Engine < ::Rails::Engine
    isolate_namespace ShinyPages

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end

    initializer 'shiny_pages.factories', after: 'factory_bot.set_factory_paths' do
      plugin_factories = File.expand_path( '../../spec/factories', __dir__ )
      FactoryBot.definition_file_paths << plugin_factories if defined? FactoryBot
    end
  end
end
