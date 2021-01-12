# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Model for page templates - part of the ShinyPages plugin for ShinyCMS
  class Template < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyHTMLTemplate
    include ShinySoftDelete

    # Associations

    has_many :pages, inverse_of: :template, dependent: :restrict_with_error

    # Class methods

    def self.template_dir
      Theme.current.template_dir( 'shiny_pages/pages' ) if Theme.current.present?
    end

    def self.admin_search( search_term )
      where( 'name ilike ?', "%#{search_term}%" )
        .or( where( 'description ilike ?', "%#{search_term}%" ) )
        .order( :name )
    end

    # Add another validation at the end, because it uses methods included/defined above
    validates :filename, inclusion: {
      in:      available_templates,
      message: I18n.t( 'models.shiny_pages.template.template_file_must_exist' )
    }
  end
end
