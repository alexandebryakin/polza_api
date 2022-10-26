# frozen_string_literal: true

module Types
  module Custom
    class BusinessCard < Types::BaseObject
      field :id, ID, null: false
      field :user_id, ID, null: false
      field :title, String, null: false
      field :subtitle, String, null: false
      field :description, String, null: true
      field :address, String, null: true
      field :status, Custom::PublicationStatusEnum, null: true
      field :phones, [Custom::Phone], null: false
      field :emails, [Custom::Email], null: false
      # field :logo, Types::Custom::AttachmentType, null: true
    end
  end
end
