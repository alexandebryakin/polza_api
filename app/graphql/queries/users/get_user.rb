# frozen_string_literal: true

module Queries
  module Users
    class GetUser < ::BaseResolver
      graphql_name OperationNames::Users::GET_USER

      argument :user_id, ID, required: true

      type Types::Custom::User, null: true

      def resolve(user_id:)
        User.find_by(id: user_id)
      end
    end
  end
end
