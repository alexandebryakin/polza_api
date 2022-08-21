# frozen_string_literal: true

module Mutations
  module Auth
    class SignupUser < BaseMutation
      graphql_name OperationNames::Auth::Users::SIGNUP

      argument :email, String, required: true
      argument :password, String, required: true

      field :token, String, null: true
      field :user, Types::UserType, null: true
      field :errors, GraphQL::Types::JSON

      def resolve(email:, password:)
        user = User.create(
          email:,
          password:
        )
        if user.valid?
          { user:, token: token(user), errors: {} }
        else
          { user: nil, token: nil, errors: user.errors.messages }
        end
      end

      private

      def token(user)
        ::Auth::JwtEncode.new.call(
          data: {
            user: {
              id: user.id
            }
          }
        )
      end
    end
  end
end
