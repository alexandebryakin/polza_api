# frozen_string_literal: true

module Mutations
  module Auth
    class SignupUser < BaseMutation
      graphql_name OperationNames::Auth::Users::SIGNUP

      argument :email, String, required: true
      argument :password, String, required: true

      field :token, String, null: true
      field :user, Types::Custom::User, null: true
      field :errors, GraphQL::Types::JSON

      def resolve(email:, password:)
        user = User.create(password:, emails_attributes: [{ email:, is_primary: true }])

        if user.valid?
          { user:, token: token(user), errors: {} }
        else
          { user: nil, token: nil, errors: transform_error_messages(user.errors.messages) }
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

      def transform_error_messages(messages)
        messages.transform_keys { _1.to_s == 'emails.email' ? 'email' : _1 }
      end
    end
  end
end
