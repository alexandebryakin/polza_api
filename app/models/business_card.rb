# frozen_string_literal: true

class BusinessCard < ApplicationRecord
  belongs_to :user
  has_many :business_cards_phones, dependent: :destroy
  has_many :phones, through: :business_cards_phones
  has_many :business_cards_emails, dependent: :destroy
  has_many :emails, through: :business_cards_emails

  PUBLICATION_STATUSES = {
    draft: 0,
    published: 1
  }

  enum :status, PUBLICATION_STATUSES

  validates :title, presence: true
  validates :subtitle, presence: true
end
