# frozen_string_literal: true

class Collection < ApplicationRecord
  belongs_to :user
  has_many :collections_business_cards, dependent: :destroy
  has_many :business_cards, through: :collections_business_cards, dependent: :destroy

  KINDS = {
    custom: 0,
    personal: 1
  }.freeze

  enum :kind, KINDS
end
