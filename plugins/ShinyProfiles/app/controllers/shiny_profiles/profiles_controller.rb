# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyProfiles
  # Main site controller for profile pages, provided by ShinyProfiles plugin for ShinyCMS
  class ProfilesController < MainController
    before_action :check_feature_flags
    before_action :authenticate_user!, except: %i[ index show ]
    before_action :stash_profile,      only:   %i[ show edit update ]
    before_action :authorize_user,     except: %i[ index show profile_redirect ]

    def index
      # TODO: searchable gallery of public user profiles
      redirect_to main_app.root_path
    end

    def show; end

    def profile_redirect
      redirect_to shiny_profiles.profile_path( current_user.username )
    end

    def edit; end

    def update
      if add_new_link && @profile.update( strong_params )
        redirect_to shiny_profiles.edit_profile_path( @profile.username ), notice: t( '.success' )
      else
        flash[ :alert ] = t( '.failure' )
        render :edit
      end
    end

    private

    def stash_profile
      @profile = Profile.for_username params[ :username ]
    end

    def authorize_user
      return true if current_user == @profile&.user

      redirect_to main_app.root_path, alert: t( '.not_authorized' )
    end

    def strong_params
      params.require( :profile ).permit(
        :public_name, :public_email, :profile_pic, :bio, :location, :postcode,
        :new_link_name, :new_link_url, links_attributes: {}
      )
    end

    def add_new_link
      name = params[ :profile ]&.delete( :new_link_name )
      url  = params[ :profile ]&.delete( :new_link_url  )

      return true if url.blank?

      @profile.links.create( name: name, url: url ).persisted?
    end

    def check_feature_flags
      enforce_feature_flags :user_profiles
    end
  end
end
