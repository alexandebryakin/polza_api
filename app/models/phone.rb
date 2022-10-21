# frozen_string_literal: true

class Phone < ApplicationRecord
  PHONE_NUM_LENGTH = 11
  belongs_to :user

  enum :verification_status, Passport::VERIFICATION_STATUSES

  validates :number, presence: true, uniqueness: true, format: { with: /\A\d+\Z/ }, length: { is: PHONE_NUM_LENGTH }
end
