module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::Auth::CreateUser
    field :login_user, mutation: Mutations::SigninUser
  end
end
