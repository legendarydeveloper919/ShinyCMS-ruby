# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Details of unauthenticated comment authors
  class CommentAuthor < ApplicationRecord
    include ShinyCMS::HasDemoData
    include ShinySoftDelete
    include ShinyToken

    has_many :comments, as: :author, dependent: :nullify

    belongs_to :email_recipient, optional: true

    def email
      return if email_recipient.blank?

      email_recipient.email
    end

    def self.demo_data_position
      12  # after comments
    end
  end
end
