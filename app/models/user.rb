# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_one :passport, required: false, dependent: :destroy
  has_many :phones, dependent: :destroy
  has_many :emails, dependent: :destroy

  # TODO: remove from user model
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
