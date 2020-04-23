# frozen_string_literal: true

# Reusable spec to check that each admin type gets redirected correctly on login
RSpec.shared_examples '/admin redirect' do |type, path, section|
  it "redirects a #{type.titlecase} correctly" do
    # rubocop:disable Rails/SaveBang
    admin = create type.to_sym
    sign_in admin
    # rubocop:enable Rails/SaveBang

    get admin_path

    expect( response      ).to have_http_status :found
    expect( response      ).to redirect_to url_for( path )
    follow_redirect!
    expect( response      ).to have_http_status :ok
    expect( response.body ).to have_title I18n.t( "admin.#{section}.index.title" ).titlecase
  end
end
