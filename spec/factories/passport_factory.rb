# frozen_string_literal: true

FactoryBot.define do
  factory :passport do
    first_name { 'John' }
    last_name  { 'Doe' }
    middle_name  { 'Metson' }
    sequence(:code) { (9_999 - _1).to_s }
    sequence(:number) { (999_999 - _1).to_s }

    trait :with_image do
      after :create do |passport|
        attachment = ActiveStorage::Blob.create_and_upload!(
          io: File.open('spec/fixtures/files/passport.jpeg'),
          filename: 'passport.jpeg',
          content_type: 'image/jpeg'
        )
        passport.image.attach(attachment)
      end
    end
  end
end
