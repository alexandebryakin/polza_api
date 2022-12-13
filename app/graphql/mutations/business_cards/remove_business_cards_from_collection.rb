# frozen_string_literal: true

module Mutations
  module BusinessCards
    class RemoveBusinessCardsFromCollection < BaseMutation
      graphql_name OperationNames::BusinessCards::REMOVE_FROM_COLLECTION

      argument :collection_id, ID, required: true
      argument :business_card_ids, [ID], required: true

      type Boolean

      def resolve(collection_id:, business_card_ids:)
        collection = current_user.collections.find_by(id: collection_id)
        collection.collections_business_cards.where(business_card_id: business_card_ids).delete_all

        true
      end
    end
  end
end
