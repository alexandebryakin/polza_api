# frozen_string_literal: true

module Mutations
  module Users
    class ChangeCurrentUserPassword < BaseMutation
      OLD_PASSWORDS_MISMATCH_ERROR = 'old passwords mismatch'
      NEW_PASSWORDS_MISMATCH_ERROR = 'new passwords mismatch'

      graphql_name OperationNames::Users::CHANGE_CURRENT_USER_PASSWORD

      argument :old_password, String, required: true
      argument :new_password, String, required: true
      argument :new_password_confirmation, String, required: true

      field :status, Types::StatusType
      field :errors, GraphQL::Types::JSON

      def resolve(**_kwargs)
        return { status: status_failure, errors: passwords_mismatch_errors } if passwords_mismatch_errors.present?

        if current_user.update(password: arguments[:new_password])
          { status: status_success, errors: {} }
        else
          { status: status_failure, errors: current_user.errors.messages }
        end
      end

      private

      def passwords_mismatch_errors
        {}.tap do |errors|
          errors[:old_password] = [OLD_PASSWORDS_MISMATCH_ERROR] if old_passwords_mismatch?
          errors[:new_password_confirmation] = [NEW_PASSWORDS_MISMATCH_ERROR] if new_passwords_mismatch?
        end
      end

      def old_passwords_mismatch?
        current_user.authenticate(arguments[:old_password]) == false
      end

      def new_passwords_mismatch?
        arguments[:new_password] != arguments[:new_password_confirmation]
      end
    end
  end
end
