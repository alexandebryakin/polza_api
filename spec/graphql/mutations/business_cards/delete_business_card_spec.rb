# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::BusinessCards::DeleteBusinessCard, type: :request do
  subject(:run_mutation) { PolzaApiSchema.execute(query, variables:, context: { current_user: user }) }

  let(:user) { create(:user) }

  let(:operation_name) { OperationNames::BusinessCards::DELETE }
  let(:query) do
    <<~GRAPHQL
      mutation #{operation_name}($id: ID!){
        deleteBusinessCard(id: $id) {
          businessCard {
            id
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
          status
          errors
        }
      }
    GRAPHQL
  end

  let(:business_card) { create(:business_card, user:) }
  let(:variables) { { id: business_card.id } }
  let(:params) do
    {
      query:,
      variables:,
      operationName: operation_name
    }
  end

  let(:mutation_result) { run_mutation.to_h }
  let(:data) { mutation_result.dig('data', 'deleteBusinessCard') }

  context 'when business card exists' do
    let!(:business_card_attrs) { business_card.attributes }

    it { expect { run_mutation }.to change { user.business_cards.count }.by(-1) }

    it 'returns business card attributes' do
      expect(data).to eq(
        'businessCard' => {
          **business_card_attrs.slice(*%w[id title subtitle description address status]),
          'phones' => [],
          'emails' => []
        },
        'status' => Types::StatusType::SUCCESS,
        'errors' => {}
      )
    end
  end

  context 'when business card doesn not belong to the current user' do
    let(:business_card) { create(:business_card, user: create(:user)) }

    before do
      business_card
    end

    it { expect { run_mutation }.not_to change(BusinessCard, :count) }

    it 'returns an errored response' do
      expect(data).to eq(
        'businessCard' => nil,
        'status' => Types::StatusType::FAILURE,
        'errors' => {
          'business_card' => [Mutations::BusinessCards::DeleteBusinessCard::NOT_FOUND]
        }
      )
    end
  end
end
