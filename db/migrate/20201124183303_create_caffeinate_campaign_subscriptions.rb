# frozen_string_literal: true

class CreateCaffeinateCampaignSubscriptions < ActiveRecord::Migration[6.0]
  def change
    drop_table :caffeinate_campaign_subscriptions if table_exists?(:caffeinate_campaign_subscriptions)

    create_table :caffeinate_campaign_subscriptions do |t|
      t.references :caffeinate_campaign, null: false, index: { name: :caffeineate_campaign_subscriptions_on_campaign }, foreign_key: true
      t.string :subscriber_type, null: false
      t.string :subscriber_id, null: false
      t.string :user_type
      t.string :user_id
      t.string :token, null: false
      t.datetime :ended_at
      t.datetime :unsubscribed_at

      t.timestamps
    end
    add_index :caffeinate_campaign_subscriptions, :token, unique: true
    add_index :caffeinate_campaign_subscriptions, %i[subscriber_id subscriber_type user_id user_type], name: :index_caffeinate_campaign_subscriptions
  end
end
