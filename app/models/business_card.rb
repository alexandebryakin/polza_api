# frozen_string_literal: true

class BusinessCard < ApplicationRecord
  belongs_to :user
  has_many :business_cards_phones, dependent: :destroy
  has_many :phones, through: :business_cards_phones
  has_many :business_cards_emails, dependent: :destroy
  has_many :emails, through: :business_cards_emails
  has_many :collections_business_cards, dependent: :destroy
  has_many :collections, through: :collections_business_cards

  PUBLICATION_STATUSES = {
    draft: 0,
    published: 1
  }.freeze

  enum :status, PUBLICATION_STATUSES

  validates :title, presence: true
  validates :subtitle, presence: true

  scope :by_collection_ids, lambda { |collection_ids|
    return if collection_ids.blank?

    joins(:collections).where(collections: { id: collection_ids })
  }
end
