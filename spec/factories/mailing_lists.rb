# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for MailingList model
FactoryBot.define do
  factory :mailing_list do
    name { Faker::Books::CultureSeries.unique.culture_ship }
    is_private { false }
  end
end
