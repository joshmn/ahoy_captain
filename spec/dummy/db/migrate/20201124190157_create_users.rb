# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    drop_table :users if table_exists?(:users)

    create_table :users do |t|
      t.string :email
      t.integer :company_id
      t.timestamps
    end
    add_index :users, :company_id
  end
end
