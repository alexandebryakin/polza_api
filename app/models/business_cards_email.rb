# frozen_string_literal: true

class BusinessCardsEmail < ApplicationRecord
  belongs_to :business_card
  belongs_to :email
end
