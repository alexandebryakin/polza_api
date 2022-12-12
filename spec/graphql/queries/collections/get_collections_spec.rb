# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Collections::GetCollections, type: :request do
  subject(:run_query) { PolzaApiSchema.execute(query, variables:, context: { current_user: user }) }

  let(:user) { create(:user) }
  let(:operation_name) { OperationNames::Collections::GET_COLLECTIONS }
  let(:query) do
    <<~GRAPHQL
      query #{operation_name}($userId: ID!, $kind: CollectionKindEnum) {
        collections(userId: $userId, kind: $kind) {
          id
          userId
          name
          kind
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
  let(:data) { query_result.dig('data', 'collections') }
  let(:variables) do
    {
      userId: user.id
    }
  end
  let(:collections) do
    [
      create(:collection, kind: :custom, user:),
      create(:collection, user: create(:user)),
      create(:collection, user:)
    ]
  end

  context 'with user_id' do
    it 'returns a list of collections by the specified user id' do
      expected_data = [collections[0], collections[2], user.collections.personal.last].map do
        {
          'id' => _1.id,
          'userId' => user.id,
          'name' => _1.name,
          'kind' => _1.kind
        }
      end

      expect(data).to match_array(expected_data)
    end
  end

  context 'with kind' do
    let(:variables) do
      {
        userId: user.id,
        kind: 'personal'
      }
    end

    it 'returns personal collections' do
      collection = user.collections.personal.first

      expect(data).to eq([{
                           'id' => collection.id,
                           'userId' => user.id,
                           'name' => collection.name,
                           'kind' => collection.kind
                         }])
    end
  end
end
