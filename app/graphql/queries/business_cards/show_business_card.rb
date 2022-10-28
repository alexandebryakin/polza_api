# frozen_string_literal: true

module Queries
  module BusinessCards
    class ShowBusinessCard < ::BaseResolver
      graphql_name OperationNames::BusinessCards::SHOW

      argument :id, ID, required: true

      type Types::Custom::BusinessCard, null: true

      def resolve(id:)
        BusinessCard.find_by(id:)
      end
    end
  end
end
