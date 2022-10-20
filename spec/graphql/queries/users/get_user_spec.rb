# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Users::GetUser, type: :request do
  subject(:run_query) { PolzaApiSchema.execute(query, variables:, context: { current_user: user }) }

  let(:user) { create(:user) }
  let(:operation_name) { OperationNames::Users::GET_USER }
  let(:query) do
    <<~GRAPHQL
      query #{operation_name}(
        $userId: ID!
      ) {
        user(userId: $userId) {
          id
          phones {
            id
            number
          }
          passport {
            id
            firstName
          }
        }
      }
    GRAPHQL
  end

  let(:params) do
    {
      query:,
      variables:,
      operationName: operation_name
    }
  end

  let(:query_result) { run_query.to_h }
  let(:data) { query_result.dig('data', 'user') }
  let(:variables) do
    {
      userId: user.id
    }
  end

  context 'with passport' do
    let!(:passport) { create(:passport, user:) }

    it 'returns a user with passport' do
      expect(data['passport']).to eq(
        'id' => passport.id,
        'firstName' => passport.first_name
      )
    end

    it 'returns a user with no phones' do
      expect(data['phones']).to eq([])
    end
  end

  context 'with phones' do
    let!(:phones) { create_list(:phone, 2, user:) }

    it 'returns user with phones' do
      expect(data['phones']).to match_array(phones.map { _1.attributes.stringify_keys.slice('id', 'number') })
    end

    it 'returns a user with no passport' do
      expect(data['passport']).to be_nil
    end
  end
end
