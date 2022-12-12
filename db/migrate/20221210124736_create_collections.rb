# frozen_string_literal: true

class CreateCollections < ActiveRecord::Migration[7.0]
  def change # rubocop:disable Metrics/MethodLength
    create_table :collections, id: :uuid do |t|
      t.string :name
      t.integer :kind, default: 0, null: false

      t.references :user, type: :uuid

      t.timestamps
    end

    create_table :collections_business_cards, id: :uuid do |t|
      t.references :collection, type: :uuid
      t.references :business_card, type: :uuid

      t.timestamps

      t.index(%i[collection_id business_card_id],
              unique: true,
              name: 'index_collections_business_cards_on_col_id_and_bus_card_id')
    end
  end
end
