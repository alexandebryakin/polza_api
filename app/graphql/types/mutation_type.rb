# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :signup_user, mutation: Mutations::Auth::SignupUser
    field :signin_user, mutation: Mutations::Auth::SigninUser

    field :upsert_passport, mutation: Mutations::Passports::Upsert

    field :add_business_cards_to_collection, mutation: Mutations::BusinessCards::AddBusinessCardsToCollection
    field :upsert_business_card, mutation: Mutations::BusinessCards::UpsertBusinessCard
    field :delete_business_card, mutation: Mutations::BusinessCards::DeleteBusinessCard

    field :create_phone, mutation: Mutations::Phones::CreatePhone
    field :create_email, mutation: Mutations::Emails::CreateEmail
  end
end
