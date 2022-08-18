module Mutations
  class SigninUser < BaseMutation
    null true

    # argument :credentials, Types::AuthProviderCredentialsInput, required: false

    field :token, String, null: true
    field :user, Types::UserType, null: true

    def resolve(credentials: nil)
      return if credentials.blank?

      user = User.find_by(email: credentials[:email])

      return if user.blank?
      return unless user.authenticate(credentials[:password])

      token = Auth::JwtEncode.new.call(
        data: {
          user: {
            id: user.id
          }
        }
      )

      { user:, token: }
    end
  end
end
