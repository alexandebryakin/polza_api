# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_one :passport, required: false, dependent: :destroy
  has_many :phones, dependent: :destroy
  has_many :emails, dependent: :destroy
  has_many :business_cards, dependent: :destroy
  has_many :collections, dependent: :destroy

  accepts_nested_attributes_for :emails

  after_create_commit :create_personal_collection!

  private

  def create_personal_collection!
    collections.create!(kind: :personal)
  end
end
