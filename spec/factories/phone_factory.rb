# frozen_string_literal: true

FactoryBot.define do
  factory :phone do
    sequence(:number) { 71_234_560_000 + _1 }
  end
end
