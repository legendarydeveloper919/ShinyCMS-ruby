# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for job that sends a single copy of a newsletter edition to a subscriber

module ShinyNewsletters
  RSpec.describe SendToSubscriberJob do
    describe '.perform_later' do
      it 'queues a send-to-subscriber job' do
        ActiveJob::Base.queue_adapter = :test

        subscriber1 = create :email_recipient
        send1       = create :newsletter_send

        expect { SendToSubscriberJob.perform_later( send1, subscriber1 ) }.to have_enqueued_job
      end
    end

    describe '.perform_now' do
      it 'attempts to trigger a mailer send' do
        ActiveJob::Base.queue_adapter = :test

        subscriber1 = create :email_recipient
        # send1       = create :newsletter_send
        send1       = create :newsletter_send_sent # TODO: This will bail out before sending

        expect( SendToSubscriberJob.perform_now( send1, subscriber1 ) ).to be_truthy
      end
    end
  end
end
