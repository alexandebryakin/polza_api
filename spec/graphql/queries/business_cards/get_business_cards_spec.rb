# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::BusinessCards::GetBusinessCards, type: :request do
  subject(:run_query) { PolzaApiSchema.execute(query, variables:, context: { current_user: user }) }

  let(:user) { create(:user) }
  let(:operation_name) { OperationNames::BusinessCards::GET_BUSINESS_CARDS }
  let(:query) do
    <<~GRAPHQL
      query #{operation_name}(
        $userId: ID,
        $collectionIds: [ID!]
      ) {
        businessCards(userId: $userId, collectionIds: $collectionIds) {
          id
          userId
          title
          subtitle
          description
          address
          status
          phones {
            number
          }
          emails {
            email
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
  let(:data) { query_result.dig('data', 'businessCards') }
  let(:variables) do
    {
      userId: user.id
    }
  end

  context 'when business card exists' do
    let!(:business_cards) { create_list(:business_card, 2, user:) }
    let!(:business_card) { create(:business_card, user: create(:user)) }

    it 'returns the list of business cards that belong to a certain user', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      expected = business_cards.map do
        {
          'id' => _1.id,
          'userId' => _1.user_id,
          'title' => _1.title,
          'subtitle' => _1.subtitle,
          'description' => _1.description,
          'address' => _1.address,
          'status' => _1.status,
          'phones' => [],
          'emails' => []
        }
      end

      expect(data).to match_array(expected)
      expect(data.map { _1['id'] }).not_to include(business_card.id)
    end
  end

  context 'when business card does not exist' do
    it { expect(data).to eq([]) }
  end

  context 'with collection_ids' do
    let!(:collection1) { create(:collection, user:, business_cards: create_list(:business_card, 1, user:)) }
    let!(:collection2) { create(:collection, user:, business_cards: create_list(:business_card, 2, user:)) }
    let!(:collection3) { create(:collection, user:, business_cards: create_list(:business_card, 3, user:)) }
    let(:variables) do
      {
        userId: user.id,
        collectionIds: [collection1.id, collection3.id]
      }
    end

    it 'returns items by collection ids' do
      expect(data.map { _1['id'] }).to match_array(
        collection1.business_cards.pluck(:id) + collection3.business_cards.pluck(:id)
      )
    end
  end

  context 'without any arguments' do
    it 'returns an empty array' do
      expect(data).to eq([])
    end
  end
end
