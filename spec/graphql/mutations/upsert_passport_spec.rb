# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::UpsertPassport, type: :request do
  subject(:run_mutation) { post('/graphql', params:, headers:) }

  let(:headers) do
    {
      'Authorization' => "Bearer #{token}"
    }
  end
  let(:user) { create(:user) }
  let!(:token) do
    Auth::JwtEncode.new.call(
      data: {
        user: {
          id: user.id
        }
      }
    )
  end

  let(:operation_name) { OperationNames::Passports::UPSERT }
  let(:query) do
    <<~GRAPHQL
      mutation #{operation_name}(
        $firstName: String!,
        $lastName: String!,
        $middleName: String!,
        $code: String!,
        $number: String!
      ){
        upsertPassport(firstName: $firstName, lastName: $lastName, middleName: $middleName, code: $code, number: $number) {
          passport {
            id
            userId
            firstName
            lastName
            middleName
            code
            number
            verified
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

  let(:response_body) { JSON.parse(response.body) }
  let(:data) { response_body.dig('data', 'upsertPassport') }

  context 'with valid data' do
    let(:variables) do
      {
        firstName: 'Arnold',
        lastName: 'Mat',
        middleName: 'Pat',
        code: '1234',
        number: '467812'
      }
    end

    it 'returns success status' do
      run_mutation

      expect(data['status']).to eq(Types::StatusType::SUCCESS)
    end

    context 'when passport does not exist' do
      it { expect { run_mutation }.to change(Passport, :count).by(1) }

      it 'creates a passport and attaches to a user', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        run_mutation

        expect(data).to eq(
          'passport' => {
            'id' => Passport.last.id,
            'userId' => user.id,
            'firstName' => variables[:firstName],
            'lastName' => variables[:lastName],
            'middleName' => variables[:middleName],
            'code' => variables[:code],
            'number' => variables[:number],
            'verified' => false
          },
          'status' => 'success',
          'errors' => {}
        )
      end
    end

    context 'when passport exists' do
      let!(:passport) { create(:passport, user:) }

      it { expect { run_mutation }.not_to change(Passport, :count) }

      it 'updates the password' do
        run_mutation

        expect(passport.reload).to have_attributes(
          first_name: variables[:firstName],
          last_name: variables[:lastName],
          middle_name: variables[:middleName],
          code: variables[:code],
          number: variables[:number]
        )
      end
    end
  end

  context 'with invalid data' do
    let(:variables) do
      {
        firstName: ' ',
        lastName: '',
        middleName: '',
        code: '12345',
        number: '46781'
      }
    end

    it 'returns failure status' do
      run_mutation

      expect(data['status']).to eq(Types::StatusType::FAILURE)
    end

    it { expect { run_mutation }.not_to change(Passport, :count) }

    it 'returns errors' do
      run_mutation

      expect(data['errors']).to eq(
        'first_name' => ["can't be blank"],
        'last_name' => ["can't be blank"],
        'middle_name' => ["can't be blank"],
        'code' => ['is invalid'],
        'number' => ['is invalid']
      )
    end
  end

  context 'with expired token' do
    let(:variables) { {} }

    it 'return an error' do
      token
      travel_to Time.current + 1.day do
        run_mutation

        expect(response.status).to eq(401)
      end
    end
  end
end
