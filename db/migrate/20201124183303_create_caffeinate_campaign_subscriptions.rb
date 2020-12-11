# frozen_string_literal: true

class CreateCaffeinateCampaignSubscriptions < ActiveRecord::Migration[6.0]
  def change
    drop_table :caffeinate_campaign_subscriptions if table_exists?(:caffeinate_campaign_subscriptions)

    create_table :caffeinate_campaign_subscriptions do |t|
      t.references :caffeinate_campaign, null: false, index: { name: :caffeineate_campaign_subscriptions_on_campaign }, foreign_key: true
      t.string :subscriber_type, null: false
      t.integer :subscriber_id, null: false
      t.string :user_type
      t.integer :user_id
      t.string :token, null: false
      t.datetime :ended_at
      t.string :ended_reason
      t.datetime :resubscribed_at
      t.datetime :unsubscribed_at
      t.string :unsubscribe_reason

      t.timestamps
    end
    add_index :caffeinate_campaign_subscriptions, :token, unique: true
    add_index :caffeinate_campaign_subscriptions, %i[caffeinate_campaign_id subscriber_id subscriber_type user_id user_type ended_at resubscribed_at unsubscribed_at], name: :index_caffeinate_campaign_subscriptions
  end
end
