# frozen_string_literal: true

module Queries
  module BusinessCards
    class GetBusinessCards < ::BaseResolver
      graphql_name OperationNames::BusinessCards::GET_BUSINESS_CARDS

      argument :user_id, ID, required: false
      argument :collection_ids, [ID], required: false

      type [Types::Custom::BusinessCard], null: false

      def resolve(user_id: nil, collection_ids: [])
        business_cards = BusinessCard.all
        business_cards = business_cards.where(user_id:) if user_id.present?
        business_cards = business_cards.by_collection_ids(collection_ids)

        business_cards == BusinessCard.all ? [] : business_cards
      end
    end
  end
end
