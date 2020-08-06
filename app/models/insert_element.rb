# frozen_string_literal: true

# Model class for Insert Elements (prev: 'shared content elements')
class InsertElement < ApplicationRecord
  include ShinyDemoDataProvider
  include ShinyElement

  belongs_to :set, inverse_of: :elements, class_name: 'InsertSet'

  validates :set, presence: true
end
