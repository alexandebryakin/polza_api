# frozen_string_literal: true

module Types
  module Custom
    class User < Types::BaseObject
      field :id, ID, null: false
      field :email, String, null: false
      field :passport, Types::PassportType, null: true
      field :phones, [Types::Custom::Phone], null: false
    end
  end
end
