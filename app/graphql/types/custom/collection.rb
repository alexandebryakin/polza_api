# frozen_string_literal: true

module Types
  module Custom
    class Collection < Types::BaseObject
      field :id, ID, null: false
      field :user_id, ID, null: false
      field :name, String, null: true
      field :kind, CollectionKindEnum, null: false
      # field :business_cards, [BusinessCard], null: false
    end
  end
end
