# frozen_string_literal: true

FactoryBot.define do
  factory :ahoy_message, class: Ahoy::Message do
    token   { Faker::Internet.unique.uuid }
    sent_at { Time.zone.now.iso8601 }

    association :user, factory: :email_recipient
  end
end
