# frozen_string_literal: true

class AddPhones < ActiveRecord::Migration[7.0]
  def change
    create_table :phones, id: :uuid do |t|
      t.string :number
      t.integer :verification_status, default: 0, null: false

      t.references :user, type: :uuid

      t.timestamps

      t.index :number, unique: true
    end
  end
end
