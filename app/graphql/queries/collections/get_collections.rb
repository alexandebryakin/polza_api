# frozen_string_literal: true

module Queries
  module Collections
    class GetCollections < ::BaseResolver
      graphql_name OperationNames::Collections::GET_COLLECTIONS

      argument :user_id, ID, required: true
      argument :kind, Types::Custom::CollectionKindEnum, required: false

      type [Types::Custom::Collection], null: false

      def resolve(user_id:, kind: nil)
        collections = Collection.joins(:user).where(user: { id: user_id })
        collections = collections.where(kind:) if kind.present?
        collections
      end
    end
  end
end
