# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :passport, resolver: Queries::Passports::GetPassport
    field :user, resolver: Queries::Users::GetUser

    field :business_card, resolver: Queries::BusinessCards::ShowBusinessCard
    field :business_cards, resolver: Queries::BusinessCards::GetBusinessCards

    field :collections, resolver: Queries::Collections::GetCollections
  end
end
