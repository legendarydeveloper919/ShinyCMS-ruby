# frozen_string_literal: true

Rails.application.config.to_prepare do
  # Make Blazer appear inside our admin UI
  # ::Blazer::BaseController.layout 'admin/layouts/admin_area'

  # Make the main_app url helpers available to Blazer's views
  # ::Blazer::BaseController.helper ::Rails.application.routes.url_helpers
end
