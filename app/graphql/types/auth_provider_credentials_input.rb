module Types
  class AuthProviderCredentialsInput < BaseInputObject
    graphql_name 'AuthProviderCredentials'

    argument :email, String, required: true
    argument :password, String, required: true
  end
end
