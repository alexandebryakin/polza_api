# frozen_string_literal: true

module Types
  class PassportType < Types::BaseObject
    class VerificationStatusType < BaseEnum
      Passport::VERIFICATION_STATUSES.each_key do |status|
        value status
      end
    end

    field :id, ID, null: false
    field :user_id, ID, null: false
    field :first_name, String, null: false
    field :last_name, String, null: false
    field :middle_name, String, null: false
    field :code, String, null: false
    field :number, String, null: false
    field :verification_status, VerificationStatusType, null: false
    field :image, Types::Custom::AttachmentType, null: true
  end
end
