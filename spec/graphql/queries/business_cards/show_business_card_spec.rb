# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::BusinessCards::ShowBusinessCard, type: :request do
  subject(:run_query) { PolzaApiSchema.execute(query, variables:, context: { current_user: user }) }

  let(:user) { create(:user) }
  let(:operation_name) { OperationNames::BusinessCards::SHOW }
  let(:query) do
    <<~GRAPHQL
      query #{operation_name}($id: ID!) {
        businessCard(id: $id) {
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
  let(:data) { query_result.dig('data', 'businessCard') }
  let(:variables) do
    {
      id: business_card_id
    }
  end

  context 'when business card exists' do
    let!(:business_card) { create(:business_card, user:) }
    let(:business_card_id) { business_card.id }

    it 'returns business card info' do # rubocop:disable RSpec/ExampleLength
      expect(data).to eq(
        'id' => business_card.id,
        'userId' => business_card.user_id,
        'title' => business_card.title,
        'subtitle' => business_card.subtitle,
        'description' => business_card.description,
        'address' => business_card.address,
        'status' => business_card.status,
        'phones' => [],
        'emails' => []
      )
    end
  end

  context 'when business card does not exist' do
    let(:business_card_id) { 'f1dcdd3d-4312-449a-a3f0-6d07a5486eae' }

    it { expect(data).to eq(nil) }
  end
end
