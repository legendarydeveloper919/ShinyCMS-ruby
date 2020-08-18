# frozen_string_literal: true

module ShinySearch
  # Helper methods for working with search back-ends
  module Searchable
    extend ActiveSupport::Concern

    included do
      def self.algolia_search_on( searchable_attributes )
        return unless algolia_search_is_enabled?

        include AlgoliaSearch

        algoliasearch unless: :hidden?, per_environment: true do
          attributes searchable_attributes
        end
      end

      def self.pg_search_on( searchable_attributes )
        return unless pg_search_is_enabled?

        include PgSearch::Model

        multisearchable against: searchable_attributes, unless: :hidden?
      end

      def self.algolia_search_is_enabled?
        ENV['ALGOLIASEARCH_APPLICATION_ID'].present?
      end

      def self.pg_search_is_enabled?
        # ActiveRecord::Base.connection.adapter_name == 'PostgreSQL' # This fires up the db too early in CI
        ENV['DISABLE_PG_SEARCH'].blank?
      end
    end
  end
end
