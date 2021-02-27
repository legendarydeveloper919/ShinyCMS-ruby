# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for page template element model
module ShinyPages
  RSpec.describe TemplateElement, type: :model do
    describe 'concerns' do
      it_behaves_like ShinyCMS::Element do
        let( :template ) { create :page_template                             }
        let( :element  ) { create :page_template_element, template: template }
      end

      it_behaves_like ShinyCMS::HasDemoData do
        let( :model ) { described_class }
      end
    end
  end
end
