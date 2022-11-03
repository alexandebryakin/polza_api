# frozen_string_literal: true

class CreateBusinessCards < ActiveRecord::Migration[7.0]
  def change # rubocop:disable Metrics/MethodLength
    create_table :business_cards, id: :uuid do |t|
      t.string :title
      t.string :subtitle
      t.string :description
      t.string :address
      t.integer :status, default: 0, null: false

      t.references :user, type: :uuid

      t.timestamps
    end

    create_table :business_cards_phones, id: :uuid do |t|
      t.references :business_card, type: :uuid
      t.references :phone, type: :uuid

      t.timestamps
    end

    create_table :business_cards_emails, id: :uuid do |t|
      t.references :business_card, type: :uuid
      t.references :email, type: :uuid

      t.timestamps
    end
  end
end
