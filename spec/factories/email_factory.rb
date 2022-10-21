# frozen_string_literal: true

FactoryBot.define do
  factory :email do
    sequence(:email) { "email_#{_1}@test.com" }
  end
end
