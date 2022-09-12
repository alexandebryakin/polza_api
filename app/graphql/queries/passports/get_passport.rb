# frozen_string_literal: true

module Queries
  module Passports
    class GetPassport < ::BaseResolver
      graphql_name OperationNames::Passports::GET_PASSPORT

      argument :user_id, ID, required: true

      type Types::PassportType, null: true

      def resolve(user_id:)
        Passport.find_by(user_id:)
      end
    end
  end
end
