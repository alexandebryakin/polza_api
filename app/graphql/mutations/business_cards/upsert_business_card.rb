# frozen_string_literal: true

module Mutations
  module BusinessCards
    class UpsertBusinessCard < BaseMutation
      graphql_name OperationNames::BusinessCards::UPSERT

      argument :id, ID, required: false
      argument :title, String, required: true
      argument :subtitle, String, required: true
      argument :description, String, required: false
      argument :address, String, required: false
      argument :status, String, required: false, default_value: :draft
      argument :phones, [String], required: true
      argument :emails, [String], required: true
      # argument :logo, ApolloUploadServer::Upload, required: true

      field :status, Types::StatusType
      field :errors, GraphQL::Types::JSON
      field :business_card, Types::Custom::BusinessCard, null: true

      def resolve(args) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        business_card = BusinessCard.find_by(id: args[:id]) || BusinessCard.new
        business_card.attributes = args.slice(:title, :subtitle, :description, :address, :status).merge(
          phones: Phone.where(number: args[:phones]),
          emails: Email.where(email: args[:emails]),
          user: current_user
        ).compact

        if business_card.save
          { status: status_success, errors: {}, business_card: }
        else
          { status: status_failure, errors: business_card.errors.messages, business_card: nil }
        end
      end
    end
  end
end
