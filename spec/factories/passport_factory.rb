# frozen_string_literal: true

FactoryBot.define do
  factory :passport do
    first_name { 'John' }
    last_name  { 'Doe' }
    middle_name  { 'Metson' }
    sequence(:code) { (9_999 - _1).to_s }
    sequence(:number) { (999_999 - _1).to_s }
    verified { false }
  end
end
