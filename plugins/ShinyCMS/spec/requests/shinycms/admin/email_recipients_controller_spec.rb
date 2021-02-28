# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for email recipient admin features
RSpec.describe ShinyCMS::Admin::EmailRecipientsController, type: :request do
  before do
    admin = create :email_recipient_admin
    sign_in admin
  end

  describe 'GET /admin/email-recipients' do
    it 'fetches the list of email recipients' do
      recipient1 = create :email_recipient
      create :email_recipient
      create :email_recipient

      get shinycms.email_recipients_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.admin.email_recipients.index.title' ).titlecase
      expect( response.body ).to have_css 'td', text: recipient1.name
    end

    it 'displays an appropriate message if there are no email recipients yet' do
      get shinycms.email_recipients_path

      none_found = 'No items found'  # TODO: i18n

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.admin.email_recipients.index.title' ).titlecase
      expect( response.body ).to have_css 'p', text: none_found
    end
  end

  describe 'GET /admin/email-recipients/search?q=movie' do
    it 'fetches the list of matching consent versions' do
      recipient1 = create :email_recipient, name: 'Awesome Alice'
      recipient2 = create :email_recipient, name: 'B-movie Bob'

      get shinycms.search_email_recipients_path, params: { q: 'movie' }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.admin.email_recipients.index.title' ).titlecase

      expect( response.body ).to     have_css 'td', text: recipient2.name
      expect( response.body ).not_to have_css 'td', text: recipient1.name
    end
  end

  describe 'DELETE /admin/email-recipients/:id/do-not-contact' do
    it 'adds the specified email recipient to the Do Not Contact list' do
      recipient1 = create :email_recipient

      email1 = recipient1.email

      put shinycms.do_not_contact_email_recipient_path( recipient1 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shinycms.email_recipients_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shinycms.admin.email_recipients.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'shinycms.admin.email_recipients.do_not_contact.success' )
      expect( response.body ).to     have_css 'td', text: recipient1.name

      expect( ShinyCMS::DoNotContact.list_includes?( email1 ) ).to be true
    end

    describe 'DELETE /admin/email-recipients/:id' do
      it 'deletes the specified email recipient' do
        recipient1 = create :email_recipient
        recipient2 = create :email_recipient
        recipient3 = create :email_recipient

        delete shinycms.email_recipient_path( recipient2 )

        expect( response      ).to     have_http_status :found
        expect( response      ).to     redirect_to shinycms.email_recipients_path
        follow_redirect!
        expect( response      ).to     have_http_status :ok
        expect( response.body ).to     have_title I18n.t( 'shinycms.admin.email_recipients.index.title' ).titlecase
        expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'shinycms.admin.email_recipients.destroy.success' )
        expect( response.body ).to     have_css 'td', text: recipient1.name
        expect( response.body ).not_to have_css 'td', text: recipient2.name
        expect( response.body ).to     have_css 'td', text: recipient3.name
      end
    end
  end
end