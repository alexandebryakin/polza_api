# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::BusinessCards::AddBusinessCardsToCollection, type: :request do
  subject(:run_mutation) { PolzaApiSchema.execute(query, variables:, context: { current_user: user }) }

  let(:user) { create(:user) }

  let(:operation_name) { OperationNames::BusinessCards::ADD_TO_COLLECTION }
  let(:query) do
    <<~GRAPHQL
      mutation #{operation_name}($collectionId: ID!, $businessCardIds: [ID!]!){
        addBusinessCardsToCollection(collectionId: $collectionId, businessCardIds: $businessCardIds)
      }
    GRAPHQL
  end

  let!(:business_cards) { create_list(:business_card, 4, user: create(:user)) }
  let!(:collection) { create(:collection, user:, business_cards: [business_cards[3]]) }
  let(:variables) do
    {
      collectionId: collection.id,
      businessCardIds: [business_cards[0].id, business_cards[2].id]
    }
  end
  let(:params) do
    {
      query:,
      variables:,
      operationName: operation_name
    }
  end

  let(:mutation_result) { run_mutation.to_h }
  let(:data) { mutation_result.dig('data', 'addBusinessCardsToCollection') }

  it 'adds business cards to a collection' do
    expect { run_mutation }.to change { collection.reload.business_cards.pluck(:id) }
      .from([business_cards[3].id])
      .to(match_array([business_cards[3].id, business_cards[0].id, business_cards[2].id]))
  end
end
