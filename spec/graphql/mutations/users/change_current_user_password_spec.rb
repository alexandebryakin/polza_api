# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Users::ChangeCurrentUserPassword, type: :request do
  subject(:run_mutation) { PolzaApiSchema.execute(query, variables:, context: { current_user: user }) }

  let(:query) do
    <<~GRAPHQL
      mutation #{operation_name}($oldPassword: String!, $newPassword: String!, $newPasswordConfirmation: String!) {
        changeCurrentUserPassword(
          oldPassword: $oldPassword,
          newPassword: $newPassword,
          newPasswordConfirmation: $newPasswordConfirmation
        ) {
          status
          errors
        }
      }
    GRAPHQL
  end
  let(:operation_name) { OperationNames::Users::CHANGE_CURRENT_USER_PASSWORD }

  let!(:user) { create(:user, password: '1234') }
  let(:mutation_result) { run_mutation.to_h }
  let(:data) { mutation_result.dig('data', 'changeCurrentUserPassword') }

  before do
    run_mutation
  end

  context 'with valid data' do
    let(:variables) do
      {
        oldPassword: '1234',
        newPassword: 'abcd',
        newPasswordConfirmation: 'abcd'
      }
    end

    it "changes user's password" do
      expect(user.reload.authenticate(variables[:newPassword])).not_to eq(false)
    end

    it 'returns success status' do
      # binding.break
      expect(data['status']).to eq(Types::StatusType::SUCCESS)
    end

    it 'returns no errors' do
      expect(data['errors']).to eq({})
    end
  end

  context 'when passwords mismatch' do
    let(:variables) do
      {
        oldPassword: '123',
        newPassword: 'abc',
        newPasswordConfirmation: 'de'
      }
    end

    it "does not change user's password" do
      expect(user.reload.authenticate(variables[:newPassword])).to eq(false)
    end

    it 'returns failure status' do
      expect(data['status']).to eq(Types::StatusType::FAILURE)
    end

    it 'returns errors hash' do
      expect(data['errors']).to eq(
        old_password: [described_class::OLD_PASSWORDS_MISMATCH_ERROR],
        new_password_confirmation: [described_class::NEW_PASSWORDS_MISMATCH_ERROR]
      )
    end
  end
end
