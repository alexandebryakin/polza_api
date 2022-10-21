# frozen_string_literal: true

module Types
  module Custom
    class Email < Types::BaseObject
      field :id, ID, null: false
      field :email, String, null: false
      field :is_primary, Boolean, null: false
      field :verification_status, VerificationStatusEnum, null: false
    end
  end
end
