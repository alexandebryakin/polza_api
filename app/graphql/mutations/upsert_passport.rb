# frozen_string_literal: true

module Mutations
  class UpsertPassport < BaseMutation
    graphql_name OperationNames::Passports::UPSERT

    argument :first_name, String, required: true
    argument :last_name, String, required: true
    argument :middle_name, String, required: true
    argument :code, String, required: true
    argument :number, String, required: true

    field :status, Types::StatusType
    field :errors, GraphQL::Types::JSON
    field :passport, Types::PassportType, null: true

    def resolve(first_name:, last_name:, middle_name:, code:, number:)
      passport = Passport.find_or_create_by(user: current_user)
      passport.update(first_name:, last_name:, middle_name:, code:, number:)

      if passport.valid?
        { status: status_success, errors: {}, passport: }
      else
        { status: status_failure, errors: passport.errors.messages, passport: nil }
      end
    end
  end
end
