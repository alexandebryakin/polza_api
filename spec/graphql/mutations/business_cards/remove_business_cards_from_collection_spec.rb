# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::BusinessCards::RemoveBusinessCardsFromCollection, type: :request do
  subject(:run_mutation) { PolzaApiSchema.execute(query, variables:, context: { current_user: user }) }

  let(:user) { create(:user) }

  let(:operation_name) { OperationNames::BusinessCards::REMOVE_FROM_COLLECTION }
  let(:query) do
    <<~GRAPHQL
      mutation #{operation_name}($collectionId: ID!, $businessCardIds: [ID!]!){
        removeBusinessCardsFromCollection(collectionId: $collectionId, businessCardIds: $businessCardIds)
      }
    GRAPHQL
  end

  let!(:business_cards) { create_list(:business_card, 4, user: create(:user)) }
  let!(:collection) { create(:collection, user:, business_cards:) }
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

  it 'remove business cards from a collection' do
    expect { run_mutation }.to change { collection.reload.business_cards.pluck(:id) }
      .from(business_cards.map(&:id))
      .to(match_array([business_cards[1].id, business_cards[3].id]))
  end
end
