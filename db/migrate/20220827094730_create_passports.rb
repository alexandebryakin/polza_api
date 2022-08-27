# frozen_string_literal: true

class CreatePassports < ActiveRecord::Migration[7.0]
  def change
    create_table :passports, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.string :middle_name

      t.string :code
      t.string :number

      t.boolean :verified, default: false

      t.references :user, type: :uuid

      t.timestamps
    end
  end
end
