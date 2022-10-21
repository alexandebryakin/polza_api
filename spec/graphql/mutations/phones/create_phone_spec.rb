# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Phones::CreatePhone, type: :request do
  subject(:run_mutation) { PolzaApiSchema.execute(query, variables:, context: { current_user: user }) }

  let(:user) { create(:user) }

  let(:operation_name) { OperationNames::Phones::CREATE }
  let(:query) do
    <<~GRAPHQL
      mutation #{operation_name}($number: String!){
        createPhone(number: $number) {
          phone {
            id
            number
            isPrimary
            verificationStatus
          }
          status
          errors
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

  let(:mutation_result) { run_mutation.to_h }
  let(:data) { mutation_result.dig('data', 'createPhone') }

  context 'with valid data' do
    let(:number_formatted) { '+7(123) 123-45-67' }
    let(:number_unformatted) { '71231234567' }
    let(:variables) do
      {
        number: number_formatted
      }
    end

    it 'returns success status' do
      expect(data['status']).to eq(Types::StatusType::SUCCESS)
    end

    context 'when phone does not exist' do
      it { expect { run_mutation }.to change { user.phones.count }.by(1) }

      it 'creates a phone and attaches to a user' do # rubocop:disable RSpec/ExampleLength
        mutation_result

        expect(data).to eq(
          'phone' => {
            'id' => user.phones.last.id,
            'number' => number_unformatted,
            'isPrimary' => false,
            'verificationStatus' => 'in_progress'
          },
          'status' => 'success',
          'errors' => {}
        )
      end
    end

    context 'when phone exists' do
      before do
        create(:phone, user:, number: number_unformatted)
      end

      it { expect { run_mutation }.not_to change(Phone, :count) }

      it 'returns an error' do
        expect(data).to eq(
          'phone' => nil,
          'status' => 'failure',
          'errors' => { number: ['has already been taken'] }
        )
      end
    end
  end

  context 'with invalid data' do
    let(:variables) do
      {
        number: 'invalid'
      }
    end

    it 'returns failure status' do
      expect(data['status']).to eq(Types::StatusType::FAILURE)
    end

    it { expect { run_mutation }.not_to change(Phone, :count) }

    it 'returns errors' do
      expect(data['errors'].stringify_keys).to eq(
        'number' => [
          "can't be blank",
          'is invalid',
          'is the wrong length (should be 11 characters)'
        ]
      )
    end
  end
end
