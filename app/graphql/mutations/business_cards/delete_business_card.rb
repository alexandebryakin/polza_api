# frozen_string_literal: true

module Mutations
  module BusinessCards
    class DeleteBusinessCard < BaseMutation
      NOT_FOUND = 'not found'

      graphql_name OperationNames::BusinessCards::DELETE

      argument :id, ID, required: true

      field :status, Types::StatusType
      field :errors, GraphQL::Types::JSON
      field :business_card, Types::Custom::BusinessCard, null: true

      def resolve(id:)
        business_card = current_user.business_cards.find_by(id:)

        return business_card_not_found_response if business_card.blank?

        if business_card.destroy
          { status: status_success, errors: {}, business_card: }
        else
          { status: status_failure, errors: business_card.errors.messages, business_card: nil }
        end
      end

      private

      def business_card_not_found_response
        {
          status: status_failure,
          errors: {
            'business_card' => [NOT_FOUND]
          },
          business_card: nil
        }
      end
    end
  end
end
