# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    enable_extension('citext')

    create_table :users, id: :uuid do |t|
      t.citext :email
      t.string :password_digest

      t.timestamps
    end

    # add_index :users, :email, unique: true, algorithm: :concurrently
  end
end
