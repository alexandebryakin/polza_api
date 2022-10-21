# frozen_string_literal: true

module Mutations
  module Emails
    class CreateEmail < BaseMutation
      graphql_name OperationNames::Emails::CREATE

      argument :email, String, required: true

      field :status, Types::StatusType
      field :errors, GraphQL::Types::JSON
      field :email, Types::Custom::Email, null: true

      def resolve(email:)
        email = current_user.emails.new(email:)
        # TODO: change auth beahvior based on emails/phones

        if email.save
          { status: status_success, errors: {}, email: }
        else
          { status: status_failure, errors: email.errors.messages, email: nil }
        end
      end
    end
  end
end
