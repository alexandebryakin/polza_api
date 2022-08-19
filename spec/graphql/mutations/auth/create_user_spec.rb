# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Auth::CreateUser, type: :request do
  subject(:run_mutation) { post('/graphql', params:) }

  let(:query) do
    <<~GRAPHQL
      mutation #{operation_name}($email: String!, $password: String!){
        createUser(email: $email, password: $password) {
          user {
            id
            email
          }
          errors
        }
      }
    GRAPHQL
  end
  let(:operation_name) { OperationNames::Auth::Users::REGISTER }

  let(:params) do
    {
      query:,
      variables:,
      operationName: operation_name
    }
  end

  let(:response_body) { JSON.parse(response.body) }

  context 'with valid data' do
    let(:variables) do
      {
        email: 'smth@email.com',
        password: '1234'
      }
    end

    it 'creates a user' do
      expect { run_mutation }.to change(User, :count).by(1)
    end

    it 'returns user attributes', :aggregate_failures do
      run_mutation

      expect(response_body.dig('data', 'createUser', 'user')).to eq(
        'id' => User.last.id,
        'email' => variables[:email]
      )
      expect(response_body.dig('data', 'createUser', 'errors')).to eq({})
    end
  end

  context 'with invalid data' do
    let(:variables) do
      {
        email: '',
        password: '1234'
      }
    end

    it 'does not create a user' do
      expect { run_mutation }.not_to change(User, :count)
    end

    it 'returns errors', :aggregate_failures do
      run_mutation

      expect(response_body.dig('data', 'createUser', 'user')).to be_nil
      expect(response_body.dig('data', 'createUser', 'errors')).to eq('email' => ["can't be blank", 'is invalid'])
    end
  end
end
