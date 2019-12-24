require 'rails_helper'

RSpec.describe 'Admin::Blog::Posts', type: :request do
  before :each do
    create :blog

    admin = create :blog_admin
    sign_in admin
  end

  describe 'GET /admin/blog/posts' do
    it 'fetches the list of blog posts' do
      get admin_blog_posts_path

      expect( response ).to have_http_status :ok
    end
  end
end
