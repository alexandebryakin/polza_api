# frozen_string_literal: true

class BusinessCardsPhone < ApplicationRecord
  belongs_to :business_card
  belongs_to :phone
end
