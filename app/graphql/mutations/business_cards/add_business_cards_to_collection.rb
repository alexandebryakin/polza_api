# frozen_string_literal: true

module Mutations
  module BusinessCards
    class AddBusinessCardsToCollection < BaseMutation
      graphql_name OperationNames::BusinessCards::ADD_TO_COLLECTION

      argument :collection_id, ID, required: true
      argument :business_card_ids, [ID], required: true

      type Boolean

      def resolve(collection_id:, business_card_ids:)
        collection = current_user.collections.find_by(id: collection_id)
        collection.business_cards << BusinessCard.where(id: business_card_ids)

        true
      end
    end
  end
end
