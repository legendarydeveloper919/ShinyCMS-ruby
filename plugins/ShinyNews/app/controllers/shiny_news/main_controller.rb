# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNews
  # Main site base controller for ShinyNews plugin for ShinyCMS
  # Inherits from ShinyCMS MainController
  class MainController < ::MainController
    helper Rails.application.routes.url_helpers

    helper_method :pagy_url_for

    private

    # Override pager link format (to news/page/NN rather than news?page=NN)
    def pagy_url_for( page, _pagy )
      params = request.query_parameters.merge( only_path: true, page: page )
      url_for( params )
    end
  end
end
