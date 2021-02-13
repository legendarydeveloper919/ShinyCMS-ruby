# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyLists
  # Model for mailing lists
  class List < ApplicationRecord
    include ShinyCMS::ShinyDemoDataProvider
    include ShinyCMS::ShinyName
    include ShinyCMS::ShinySlug
    include ShinyCMS::ShinySoftDelete

    # Assocations

    has_many :subscriptions, inverse_of: :list, dependent: :destroy
    has_many :users, through: :subscriptions, inverse_of: :lists, source: :subscriber, source_type: 'User'
    has_many :email_recipients, through: :subscriptions, inverse_of: :lists, source: :subscriber,
                                source_type: 'EmailRecipient'

    # Scopes

    scope :recently_updated, -> { order( updated_at: :desc ) }

    # Instance methods

    def subscribe( subscriber, consent_version )
      existing = subscriptions.find_by( subscriber: subscriber )

      return existing.update!( consent_version: consent_version, updated_at: Time.zone.now ) if existing

      subscriptions.create!( subscriber: subscriber, consent_version: consent_version )
    end

    def subscribed?( email_address )
      email_recipients.exists?( email: email_address ) || users.exists?( email: email_address )
    end

    # Class methods

    def self.admin_search( search_term )
      where( 'internal_name ilike ?', "%#{search_term}%" )
        .or( where( 'slug ilike ?', "%#{search_term}%" ) )
        .order( :internal_name )
    end
  end
end

::EmailRecipient.has_many :subscriptions, -> { active },
                          as: :subscriber, dependent: :destroy, class_name: 'ShinyLists::Subscription'
::EmailRecipient.has_many :lists, through: :subscriptions, inverse_of: :email_recipients, class_name: 'ShinyLists::List'

::User.has_many :subscriptions, -> { active },
                as: :subscriber, dependent: :destroy, class_name: 'ShinyLists::Subscription'
::User.has_many :lists, through: :subscriptions, inverse_of: :users, class_name: 'ShinyLists::List'
