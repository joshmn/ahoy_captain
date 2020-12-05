# frozen_string_literal: true

class CreateCaffeinateCampaigns < ActiveRecord::Migration[6.0]
  def change
    drop_table :caffeinate_campaigns if table_exists?(:caffeinate_campaigns)
    create_table :caffeinate_campaigns do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
    add_index :caffeinate_campaigns, :slug, unique: true
  end
end
