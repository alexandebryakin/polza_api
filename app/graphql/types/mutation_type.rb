# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::Auth::CreateUser
    field :signin_user, mutation: Mutations::Auth::SigninUser
  end
end
