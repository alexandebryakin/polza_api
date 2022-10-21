# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Emails::CreateEmail, type: :request do
  subject(:run_mutation) { PolzaApiSchema.execute(query, variables:, context: { current_user: user }) }

  let(:user) { create(:user) }

  let(:operation_name) { OperationNames::Emails::CREATE }
  let(:query) do
    <<~GRAPHQL
      mutation #{operation_name}($email: String!){
        createEmail(email: $email) {
          email {
            id
            email
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
  let(:data) { mutation_result.dig('data', 'createEmail') }

  context 'with valid data' do
    let(:variables) do
      {
        email: 'user@org.com'
      }
    end

    it 'returns success status' do
      expect(data['status']).to eq(Types::StatusType::SUCCESS)
    end

    context 'when email does not exist' do
      it { expect { run_mutation }.to change { user.emails.count }.by(1) }

      it 'creates an email and attaches to a user' do # rubocop:disable RSpec/ExampleLength
        mutation_result

        expect(data).to eq(
          'email' => {
            'id' => Email.last.id,
            'email' => variables[:email],
            'isPrimary' => false,
            'verificationStatus' => 'in_progress'
          },
          'status' => 'success',
          'errors' => {}
        )
      end
    end

    context 'when email exists' do
      before do
        create(:email, user:, email: variables[:email])
      end

      it { expect { run_mutation }.not_to change(Email, :count) }

      it 'returns an error' do
        expect(data).to eq(
          'email' => nil,
          'status' => 'failure',
          'errors' => { email: ['has already been taken'] }
        )
      end
    end
  end

  context 'with invalid data' do
    let(:variables) do
      {
        email: 'invalid-email'
      }
    end

    it 'returns failure status' do
      expect(data['status']).to eq(Types::StatusType::FAILURE)
    end

    it { expect { run_mutation }.not_to change(Email, :count) }

    it 'returns errors' do
      expect(data['errors'].stringify_keys).to eq(
        'email' => ['is invalid']
      )
    end
  end
end
