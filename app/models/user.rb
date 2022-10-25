# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_one :passport, required: false, dependent: :destroy
  has_many :phones, dependent: :destroy
  has_many :emails, dependent: :destroy
  has_many :business_cards, dependent: :destroy

  accepts_nested_attributes_for :emails
end
