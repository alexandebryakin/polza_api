# frozen_string_literal: true

module Queries
  module BusinessCards
    class GetBusinessCards < ::BaseResolver
      graphql_name OperationNames::BusinessCards::GET_BUSINESS_CARD

      argument :user_id, ID, required: true

      type [Types::Custom::BusinessCard], null: true

      def resolve(user_id:)
        BusinessCard.where(user_id:)
      end
    end
  end
end
