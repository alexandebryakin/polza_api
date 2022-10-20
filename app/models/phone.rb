# frozen_string_literal: true

class Phone < ApplicationRecord
  PHONE_NUM_LENGTH = 11
  belongs_to :user

  VERIFICATION_STATUSES = {
    in_progress: 0,
    succeeded: 1,
    failed: 2
  }.freeze

  enum :verification_status, VERIFICATION_STATUSES

  validates :number, presence: true, uniqueness: true, format: { with: /\A\d+\Z/ }, length: { is: PHONE_NUM_LENGTH }
end
