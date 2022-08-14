class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    enable_extension('citext')

    create_table :users, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.citext :email
      t.string :password_digest

      t.timestamps
    end

    # add_index :users, :email, unique: true, algorithm: :concurrently
  end
end
