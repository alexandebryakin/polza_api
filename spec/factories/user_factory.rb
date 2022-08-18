FactoryBot.define do
  factory :user do
    first_name { 'John' }
    last_name  { 'Doe' }
    sequence(:email) { "email_#{_1}@test.com" }
  end
end
