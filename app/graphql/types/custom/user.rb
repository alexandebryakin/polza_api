# frozen_string_literal: true

module Types
  module Custom
    class User < Types::BaseObject
      field :id, ID, null: false
      field :passport, Types::PassportType, null: true
      field :phones, [Types::Custom::Phone], null: false
      field :emails, [Types::Custom::Email], null: false
      field :collections, [Types::Custom::Collection], null: false
    end
  end
end
