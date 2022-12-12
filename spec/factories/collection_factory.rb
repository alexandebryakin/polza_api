# frozen_string_literal: true

FactoryBot.define do
  factory :collection do
    sequence(:name) { "collection_#{_1}" }
  end
end
