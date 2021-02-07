# frozen_string_literal: true

# ShinySEO plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinySEO
  # Base controller for ShinySEO admin features
  # Inherits from ShinyCMS AdminController
  class AdminController < ::AdminController
    helper Rails.application.routes.url_helpers
  end
end
