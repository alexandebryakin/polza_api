# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::BusinessCards::UpsertBusinessCard, type: :request do
  subject(:run_mutation) { PolzaApiSchema.execute(query, variables:, context: { current_user: user }) }

  let(:user) do
    create(:user) do |record|
      create_list(:phone, 2, user: record)
      create_list(:email, 2, user: record)
    end
  end

  let(:operation_name) { OperationNames::BusinessCards::UPSERT }
  let(:query) do
    <<~GRAPHQL
      mutation #{operation_name}(
        $id: ID,
        $title: String!,
        $subtitle: String!,
        $description: String,
        $address: String,
        $status: PublicationStatusEnum,
        $phones: [String!]!,
        $emails: [String!]!,
      ){
        upsertBusinessCard(
          id: $id,
          title: $title,
          subtitle: $subtitle,
          description: $description,
          address: $address,
          status: $status,
          phones: $phones,
          emails: $emails,
        ) {
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

  let(:params) do
    {
      query:,
      variables:,
      operationName: operation_name
    }
  end

  let(:mutation_result) { run_mutation.to_h }
  let(:data) { mutation_result.dig('data', 'upsertBusinessCard') }
  let(:business_card_attrs) do
    {
      title: 'Trofimova Elena Ivanovna',
      subtitle: 'UX/UI designer',
      description: 'Some desc',
      address: 'Pushkina street',
      phones: user.phones.last(2).pluck(:number),
      emails: user.emails.last(2).pluck(:email)
    }
  end

  context 'with valid data' do
    let(:variables) { business_card_attrs.merge(id: nil) }

    it 'returns success status' do
      expect(data['status']).to eq(Types::StatusType::SUCCESS)
    end

    context 'when business card does not exist' do
      it { expect { run_mutation }.to change(BusinessCard, :count).by(1) }

      it 'creates a business card and attaches to a user', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        expect(data).to eq(
          'businessCard' => {
            'id' => user.business_cards.last.id,
            'title' => variables[:title],
            'subtitle' => variables[:subtitle],
            'description' => variables[:description],
            'address' => variables[:address],
            'status' => 'draft',
            'phones' => variables[:phones].sort.map { { 'number' => _1 } },
            'emails' => variables[:emails].sort.map { { 'email' => _1 } }
          },
          'status' => 'success',
          'errors' => {}
        )
      end
    end

    context 'when business card exists' do
      let!(:business_card) { create(:business_card, user:) }
      let(:variables) { business_card_attrs.merge(id: business_card.id) }

      it { expect { run_mutation }.not_to change(BusinessCard, :count) }

      it 'updates the business card' do
        run_mutation

        expect(business_card.reload).to have_attributes(
          title: variables[:title],
          subtitle: variables[:subtitle],
          description: variables[:description],
          address: variables[:address],
          phones: Phone.where(number: variables[:phones]),
          emails: Email.where(email: variables[:emails])
        )
      end
    end
  end

  context 'with invalid data' do
    let(:variables) do
      business_card_attrs.merge(
        title: ' ',
        subtitle: ''
      )
    end

    it 'returns failure status' do
      expect(data['status']).to eq(Types::StatusType::FAILURE)
    end

    it { expect { run_mutation }.not_to change(BusinessCard, :count) }
    it { expect { run_mutation }.not_to change(BusinessCardsPhone, :count) }
    it { expect { run_mutation }.not_to change(BusinessCardsEmail, :count) }

    it 'returns errors' do
      expect(data['errors'].stringify_keys).to eq(
        'title' => ["can't be blank"],
        'subtitle' => ["can't be blank"]
      )
    end
  end
end
