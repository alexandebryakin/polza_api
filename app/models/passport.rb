# frozen_string_literal: true

class Passport < ApplicationRecord
  REGEXP_CODE = /\A([0-9]{4})\z/
  REGEXP_NUMBER = /\A([0-9]{6})\z/

  VERIFICATION_STATUSES = {
    in_progress: 0,
    succeded: 1,
    failed: 2
  }.freeze

  enum :verification_status, VERIFICATION_STATUSES

  has_one_attached :image

  belongs_to :user

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :middle_name, presence: true

  validates :code, presence: true, format: { with: REGEXP_CODE }
  validates :number, presence: true, format: { with: REGEXP_NUMBER }
end
