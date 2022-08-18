module Mutations
  module Auth
    class CreateUser < BaseMutation
      graphql_name OperationNames::Auth::Users::REGISTER

      argument :email, String, required: true
      argument :password, String, required: true

      field :user, Types::UserType, null: true
      field :errors, GraphQL::Types::JSON, null: true

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
