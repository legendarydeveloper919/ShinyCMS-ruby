# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Provides convenience methods for interacting with ShinyCMS plugins
  class Plugin
    attr_reader :name

    def initialize( name )
      return unless [ 'ShinyCMS', Plugin.all_names ].flatten.include? name

      @name = name
    end

    # Instance methods

    def engine
      @engine ||= name.constantize::Engine
    end

    def base_model
      @base_model ||= name.constantize::ApplicationRecord if defined? name.constantize::ApplicationRecord
    end

    def main_site_helper
      @main_site_helper ||= name.constantize::MainSiteHelper if defined? name.constantize::MainSiteHelper
    end

    def models_that_are( method )
      base_model.descendants.select( &method )
    end

    def models_that_respond_to( method )
      base_model.descendants.select { |model| model.respond_to?( method ) }
    end

    def view_path
      return unless File.exist? Rails.root.join( "plugins/#{name}/app/views/" )

      "plugins/#{name}/app/views/#{name.underscore}"
    end

    def template_exists?( template_path )
      File.exist? "#{view_path}/#{template_path}"
    end

    def routes
      engine.routes.routes.routes # er, okay
    end

    # Class methods

    # Returns an array of the currently enabled plugins
    def self.loaded
      Plugins.loaded
    end

    def self.loaded?( plugin_name )
      Plugins.include? plugin_name
    end

    def self.all_routes
      Plugins.all_routes
    end

    def self.taggable_models
      Plugins.taggable_models
    end

    def self.votable_models
      Plugins.votable_models
    end

    def self.models_with_demo_data
      Plugins.models_with_demo_data
    end

    def self.models_with_sitemap_items
      Plugins.models_with_sitemap_items
    end

    def self.with_main_site_helpers
      Plugins.with_main_site_helpers
    end

    def self.with_models
      Plugins.with_models
    end

    def self.with_views
      Plugins.with_views
    end

    def self.with_template( template_path )
      Plugins.with_template( template_path )
    end

    def self.models_that_are( method )
      Plugins.models_that_are( method )
    end

    def self.models_that_respond_to( method )
      Plugins.models_that_respond_to( method )
    end

    def self.loaded_names
      Plugins.names
    end

    def self.configured_names
      requested = ENV[ 'SHINYCMS_PLUGINS' ]&.split( /[, ]+/ )

      return requested.uniq.select { |name| all_names.include?( name ) } if requested.present?
    end

    def self.all_names
      Dir[ 'plugins/*' ].collect { |plugin_name| plugin_name.sub( 'plugins/', '' ) } - [ 'ShinyCMS' ]
    end
  end
end
