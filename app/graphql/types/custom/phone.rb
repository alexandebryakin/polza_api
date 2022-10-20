# frozen_string_literal: true

module Types
  module Custom
    class Phone < Types::BaseObject
      field :id, ID, null: false
      field :number, String, null: false
    end
  end
end
