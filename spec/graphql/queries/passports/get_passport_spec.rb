# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Passports::GetPassport, type: :request do
  subject(:run_query) { PolzaApiSchema.execute(query, variables:, context: { current_user: user }) }

  let(:user) { create(:user) }
  let(:operation_name) { OperationNames::Passports::GET_PASSPORT }
  let(:query) do
    <<~GRAPHQL
      query #{operation_name}(
        $userId: ID!
      ) {
        passport(userId: $userId) {
          id
          userId
          firstName
          lastName
          middleName
          code
          number
          verificationStatus
          image {
            url
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
  let(:data) { query_result.dig('data', 'passport') }
  let(:variables) do
    {
      userId: user.id
    }
  end

  context 'when passport exists' do
    let!(:passport) { create(:passport, :with_image, user:) }

    it 'returns success status' do # rubocop:disable RSpec/ExampleLength
      expect(data).to eq(
        'id' => passport.id,
        'userId' => user.id,
        'firstName' => passport.first_name,
        'lastName' => passport.last_name,
        'middleName' => passport.middle_name,
        'code' => passport.code,
        'number' => passport.number,
        'verificationStatus' => 'in_progress',
        'image' => {
          'url' => Rails.application.routes.url_helpers.rails_blob_url(passport.image, host: ENV.fetch('HOST'))
        }
      )
    end
  end

  context 'when passport does not exist' do
    it { expect(data).to be_nil }
  end
end
