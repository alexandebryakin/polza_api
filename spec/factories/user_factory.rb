# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    # TODO: remove email
    sequence(:email) { "email_#{_1}@test.com" }
    password { '1111' }
  end
end
