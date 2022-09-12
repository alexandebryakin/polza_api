# frozen_string_literal: true

module Mutations
  module Passports
    class Upsert < BaseMutation
      graphql_name OperationNames::Passports::UPSERT

      argument :first_name, String, required: true
      argument :last_name, String, required: true
      argument :middle_name, String, required: true
      argument :code, String, required: true
      argument :number, String, required: true
      argument :image, ApolloUploadServer::Upload, required: true

      field :status, Types::StatusType
      field :errors, GraphQL::Types::JSON
      field :passport, Types::PassportType, null: true

      def resolve(first_name:, last_name:, middle_name:, code:, number:, image:) # rubocop:disable Metrics/ParameterLists
        passport = Passport.find_or_create_by(user: current_user)
        passport.update(first_name:, last_name:, middle_name:, code:, number:, verification_status: :in_progress)
        attachment = ActiveStorage::Blob.create_and_upload!(io: image, filename: image.original_filename,
                                                            content_type: image.content_type)
        passport.image.attach(attachment)

        if passport.valid?
          { status: status_success, errors: {}, passport: }
        else
          { status: status_failure, errors: passport.errors.messages, passport: nil }
        end
      end
    end
  end
end
