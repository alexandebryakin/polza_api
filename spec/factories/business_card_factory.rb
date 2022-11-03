# frozen_string_literal: true

FactoryBot.define do
  factory :business_card do
    sequence(:title) { "Business Card #{_1}" }
    subtitle { 'UX/UI designer' }
    description { 'bla-bla' }
    address { 'Moscow, Non-existing prospect' }
  end
end
