# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common behaviour for ShinyCMS admin controllers
  module AdminControllers
    extend ActiveSupport::Concern

    included do
      include ShinyCMS::Controllers

      include ShinyCMS::Admin::AccessControlByIP

      include Pundit

      helper ShinyCMS::AdminAreaHelper

      before_action :authenticate_user!
      before_action :cache_user_capabilities

      after_action :verify_authorized

      layout 'admin/layouts/admin_area'

      private

      def cache_user_capabilities
        current_user&.cache_capabilities
      end
    end
  end
end
