# frozen_string_literal: true

# ============================================================================
# Project:   ShinyPages plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyPages/app/policies/shiny_pages/section_policy.rb
# Purpose:   Pundit policy for admin area features
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

module ShinyPages
  # Pundit policy for pages - part of the ShinyPages plugin for ShinyCMS
  class SectionPolicy
    attr_reader :this_user, :record

    def initialize( this_user, record )
      @this_user = this_user
      @record = record
    end

    def index?
      @this_user.can? :list, :pages
    end

    def new?
      @this_user.can? :list, :pages
    end

    def create?
      new?
    end

    def edit?
      @this_user.can? :edit, :pages
    end

    def update?
      edit?
    end

    def destroy?
      @this_user.can? :destroy, :pages
    end
  end
end
