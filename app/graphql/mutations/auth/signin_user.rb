# frozen_string_literal: true

module Mutations
  module Auth
    class SigninUser < BaseMutation
      CANT_BE_BLANK = "can't be blank"
      NOT_FOUND = 'not found'
      INVALID_CREDENTIALS = 'invalid credentials'

      graphql_name OperationNames::Auth::Users::SIGNIN

      argument :email, String, required: true
      argument :password, String, required: true

      field :token, String, null: true
      field :user, Types::Custom::User, null: true
      field :errors, GraphQL::Types::JSON

      def resolve(email:, password:) # rubocop:disable Metrics/MethodLength
        return wrap_response(empty_credentials_errors) if empty_credentials_errors.present?

        user = User.joins(:emails).find_by(emails: { email: })

        return wrap_response(user: [NOT_FOUND]) if user.blank?
        return wrap_response(user: [INVALID_CREDENTIALS]) unless user.authenticate(password)

        token = ::Auth::JwtEncode.new.call(
          data: {
            user: {
              id: user.id
            }
          }
        )

        { token:, user:, errors: {} }
      end

      private

      def wrap_response(errors)
        { token: nil, user: nil, errors: }
      end

      def empty_credentials_errors
        @empty_credentials_errors ||= {}.tap do |errors|
          errors[:email] = [CANT_BE_BLANK] if arguments[:email].blank?
          errors[:password] = [CANT_BE_BLANK] if arguments[:password].blank?
        end
      end
    end
  end
end
