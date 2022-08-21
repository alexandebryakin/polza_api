# frozen_string_literal: true

module Mutations
  module Auth
    class SignupUser < BaseMutation
      graphql_name OperationNames::Auth::Users::SIGNUP

      argument :email, String, required: true
      argument :password, String, required: true

      field :user, Types::UserType, null: true
      field :errors, GraphQL::Types::JSON

      def resolve(email:, password:)
        user = User.create(
          email:,
          password:
        )
        if user.valid?
          { user:, errors: {} }
        else
          { user: nil, errors: user.errors.messages }
        end
      end
    end
  end
end
