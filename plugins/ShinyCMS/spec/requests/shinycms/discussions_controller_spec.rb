# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for discussion and comment features on main site
RSpec.describe ShinyCMS::DiscussionsController, type: :request do
  before do
    ShinyCMS::FeatureFlag.enable :news
    ShinyCMS::FeatureFlag.enable :comments

    ShinyCMS::FeatureFlag.disable :recaptcha_for_comments
    ShinyCMS::FeatureFlag.disable :akismet_for_comments

    @post = create :news_post

    @discussion = create :discussion, resource: @post
    @post.update!( discussion: @discussion )

    cmntr = create :user
    create :top_level_comment, discussion: @discussion
    @comment = create :top_level_comment, discussion: @discussion, author: cmntr
    create :top_level_comment, discussion: @discussion

    @nested = create :nested_comment, discussion: @discussion, parent: @comment

    WebMock.disable!
  end

  describe 'GET /discussions' do
    it 'displays the current most active discussions' do
      get shinycms.discussions_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.discussions.index.title' )
      expect( response.body ).to have_css 'h2', text: I18n.t( 'shinycms.discussions.index.recently_active' )
    end
  end

  describe 'GET /news/1999/12/testing' do
    it 'loads a news post and its comments' do
      get "/news/#{@post.posted_year}/#{@post.posted_month}/#{@post.slug}"

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h3', text: I18n.t( 'shinycms.discussions.comments' )
      expect( response.body ).to have_css 'h2', text: @comment.title
      expect( response.body ).to have_css 'h2', text: @nested.title
    end

    it 'loads a news post with an empty discussion' do
      @discussion.comments.delete_all

      get "/news/#{@post.posted_year}/#{@post.posted_month}/#{@post.slug}"

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h3', text: I18n.t( 'shinycms.discussions.comments' )
      expect( response.body ).to have_css 'p',  text: I18n.t( 'shinycms.empty_list', items: 'comments' )
    end

    it 'loads a news post with no discussion attached' do
      @post.update!( discussion: nil )

      get "/news/#{@post.posted_year}/#{@post.posted_month}/#{@post.slug}"

      expect( response      ).to     have_http_status :ok
      expect( response.body ).not_to have_css 'h3', text: I18n.t( 'shinycms.discussions.comments' )
    end
  end

  describe 'GET /discussion/1' do
    it 'displays a discussion, without its parent resource' do
      get shinycms.discussion_path( @discussion )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h2', text: @comment.title
      expect( response.body ).to have_css 'h2', text: @nested.title
    end

    it "renders the 404 page if the discussion doesn't exist", :production_error_responses do
      get shinycms.discussion_path( 999 )

      expect( response      ).to have_http_status :not_found
      expect( response.body ).to have_css 'h2', text: I18n.t(
        'shinycms.errors.not_found.title', resource_type: 'Page'
      )
    end
  end

  describe 'GET /discussion/1/1' do
    it 'displays a comment and any replies to it' do
      get shinycms.comment_path( @discussion, @comment.number )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h2', text: @comment.title
      expect( response.body ).to have_css 'h2', text: @nested.title
    end

    it "renders the 404 page if the comment doesn't exist", :production_error_responses do
      get shinycms.comment_path( @discussion, 999 )

      expect( response      ).to have_http_status :not_found
      expect( response.body ).to have_css 'h2', text: I18n.t(
        'shinycms.errors.not_found.title', resource_type: 'Page'
      )
    end
  end

  describe 'POST /discussion/1' do
    it 'adds a new top-level comment to the discussion' do
      title = Faker::Books::CultureSeries.unique.culture_ship
      body  = Faker::Lorem.paragraph

      post shinycms.discussion_path( @discussion ), params: {
        comment: {
          title: title,
          body:  body
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.discussion_path( @discussion )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shinycms.discussions.add_comment.success' )
      expect( response.body ).to have_css 'h2', text: title
      expect( response.body ).to include body
    end

    it 'adds a new comment by a logged-in user' do
      user = create :user
      sign_in user

      title = Faker::Books::CultureSeries.unique.culture_ship
      body  = Faker::Lorem.paragraph

      post shinycms.discussion_path( @discussion ), params: {
        comment: {
          title: title,
          body:  body
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.discussion_path( @discussion )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shinycms.discussions.add_comment.success' )
      expect( response.body ).to have_css 'h2', text: title
      expect( response.body ).to have_css 'h3', text: user.username
    end

    it 'adds a new comment by a pseudonymous user' do
      name = Faker::Name.unique.name
      title = Faker::Books::CultureSeries.unique.culture_ship

      post shinycms.discussion_path( @discussion ), params: {
        comment: {
          author_name:  name,
          author_email: Faker::Internet.unique.email,
          title:        title,
          body:         Faker::Lorem.paragraph
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.discussion_path( @discussion )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shinycms.discussions.add_comment.success' )
      expect( response.body ).to have_css 'h2', text: title
      expect( response.body ).to have_css 'h3', text: name
    end

    it 'fails to post a top-level comment with missing fields' do
      post shinycms.discussion_path( @discussion ), params: {
        comment: {
          title: nil,
          body:  nil
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'shinycms.discussions.add_comment.failure' )
    end

    it 'adds a new top-level comment to the discussion, with a recaptcha check' do
      allow_any_instance_of( described_class ).to receive( :recaptcha_v3_site_key ).and_return( 'A_KEY' )
      allow( described_class ).to receive( :recaptcha_v3_secret_key ).and_return( 'A_KEY' )

      ShinyCMS::FeatureFlag.enable :recaptcha_for_comments

      title = Faker::Books::CultureSeries.unique.culture_ship
      body  = Faker::Lorem.paragraph

      post shinycms.discussion_path( @discussion ), params: {
        comment: {
          title: title,
          body:  body
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.discussion_path( @discussion )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shinycms.discussions.add_comment.success' )
      expect( response.body ).to have_css 'h2', text: title
      expect( response.body ).to include body
    end

    it 'classifies a new comment as spam after checking Akismet' do
      ShinyCMS::FeatureFlag.enable :akismet_for_comments
      allow_any_instance_of( Akismet::Client ).to receive( :open  )
      allow_any_instance_of( Akismet::Client ).to receive( :check ).and_return( [ true, false ] )

      always_fail_author_name = 'viagra-test-123'
      title = Faker::Books::CultureSeries.unique.culture_ship
      body  = Faker::Lorem.paragraph

      post shinycms.discussion_path( @discussion ), params: {
        comment: {
          title:       title,
          body:        body,
          author_name: always_fail_author_name
        }
      }

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to shinycms.discussion_path( @discussion )
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( ShinyCMS::Comment.last.spam ).to be true

      expect( response.body ).not_to have_css '.notices', text: I18n.t( 'shinycms.discussions.add_comment.success' )
      expect( response.body ).not_to have_css 'h2', text: title
    end

    it "doesn't save a new comment if Akismet classifies it as 'blatant' spam" do
      ShinyCMS::FeatureFlag.enable :akismet_for_comments
      allow_any_instance_of( Akismet::Client ).to receive( :open  )
      allow_any_instance_of( Akismet::Client ).to receive( :check ).and_return( [ true, true ] )

      name  = Faker::Name.unique.name
      email = Faker::Internet.unique.email
      title = Faker::Books::CultureSeries.unique.culture_ship
      body  = Faker::Lorem.paragraph

      comment_count   = ShinyCMS::Comment.count
      author_count    = ShinyCMS::PseudonymousAuthor.count
      recipient_count = ShinyCMS::EmailRecipient.count

      post shinycms.discussion_path( @discussion ), params: {
        comment: {
          author_name:  name,
          author_email: email,
          title:        title,
          body:         body
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).not_to have_css '.notices', text: I18n.t( 'shinycms.discussions.add_comment.success' )
      expect( response.body ).not_to have_css 'h2', text: title

      expect( ShinyCMS::Comment.count            ).to eq comment_count
      expect( ShinyCMS::PseudonymousAuthor.count ).to eq author_count
      expect( ShinyCMS::EmailRecipient.count     ).to eq recipient_count
    end
  end

  describe 'POST /discussion/1/1' do
    it 'adds a new comment as a reply to an existing comment' do
      title = Faker::Books::CultureSeries.unique.culture_ship
      body  = Faker::Lorem.paragraph

      post shinycms.comment_path( @discussion, @comment.number ), params: {
        comment: {
          title: title,
          body:  body
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.discussion_path( @discussion )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shinycms.discussions.add_reply.success' )
      expect( response.body ).to have_css 'h2', text: title
      expect( response.body ).to include body
    end

    it 'fails to post a reply with missing fields' do
      post shinycms.comment_path( @discussion, @comment.number ), params: {
        comment: {
          title: nil,
          body:  nil
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'shinycms.discussions.add_reply.failure' )
    end
  end
end