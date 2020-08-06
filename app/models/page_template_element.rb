# frozen_string_literal: true

# Model class for template elements
class PageTemplateElement < ApplicationRecord
  include ShinyDemoDataProvider
  include ShinyElement

  belongs_to :template, inverse_of: :elements, class_name: 'PageTemplate'

  validates :template, presence: true
end
