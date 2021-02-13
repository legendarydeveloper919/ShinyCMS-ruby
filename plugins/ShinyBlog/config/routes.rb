# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

ShinyBlog::Engine.routes.draw do
  scope format: false do
    # Main site
    get 'blog(/page/:page)',        to: 'blog#index', as: :view_blog

    get 'blog/:year',               constraints: { year: %r{\d\d\d\d} },
                                    to: 'blog#year', as: :view_blog_year

    get 'blog/:year/:month',        constraints: { year: %r{\d\d\d\d}, month: %r{\d\d} },
                                    to: 'blog#month', as: :view_blog_month

    get 'blog/:year/:month/:slug',  constraints: { year: %r{\d\d\d\d}, month: %r{\d\d} },
                                    to: 'blog#show', as: :view_blog_post

    # Admin area
    scope path: 'admin', module: 'admin' do
      concern :with_paging do
        get '(page/:page)', action: :index, on: :collection, as: ''
      end
      concern :with_search do
        get :search, on: :collection
      end

      resources :blog_posts, path: 'blog', except: %i[ index show ], concerns: %i[ with_paging with_search ]
    end
  end
end
