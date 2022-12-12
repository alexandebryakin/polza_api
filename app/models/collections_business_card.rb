# frozen_string_literal: true

class CollectionsBusinessCard < ApplicationRecord
  belongs_to :collection
  belongs_to :business_card
end
