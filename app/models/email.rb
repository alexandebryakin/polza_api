# frozen_string_literal: true

class Email < ApplicationRecord
  belongs_to :user

  enum :verification_status, Passport::VERIFICATION_STATUSES

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
