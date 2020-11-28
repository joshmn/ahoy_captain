# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_201_124_190_157) do
  create_table 'caffeinate_campaign_subscriptions', force: :cascade do |t|
    t.integer 'caffeinate_campaign_id', null: false
    t.string 'subscriber_type', null: false
    t.string 'subscriber_id', null: false
    t.string 'user_type'
    t.string 'user_id'
    t.string 'token', null: false
    t.datetime 'ended_at'
    t.datetime 'resubscribed_at'
    t.datetime 'unsubscribed_at'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['caffeinate_campaign_id'], name: 'caffeineate_campaign_subscriptions_on_campaign'
    t.index %w[subscriber_id subscriber_type user_id user_type], name: 'index_caffeinate_campaign_subscriptions'
    t.index ['token'], name: 'index_caffeinate_campaign_subscriptions_on_token', unique: true
  end

  create_table 'caffeinate_campaigns', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'slug', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['slug'], name: 'index_caffeinate_campaigns_on_slug', unique: true
  end

  create_table 'caffeinate_mailings', force: :cascade do |t|
    t.integer 'caffeinate_campaign_subscription_id', null: false
    t.datetime 'send_at'
    t.datetime 'sent_at'
    t.datetime 'skipped_at'
    t.string 'mailer_class', null: false
    t.string 'mailer_action', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index '"campaign_subscription_id", "mailer_class", "mailer_action", "sent_at", "send_at", "skipped_at"', name: 'index_caffeinate_mailings'
    t.index ['caffeinate_campaign_subscription_id'], name: 'index_caffeinate_mailings_on_campaign_subscription'
  end

  create_table 'companies', force: :cascade do |t|
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email'
    t.integer 'company_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['company_id'], name: 'index_users_on_company_id'
  end

  add_foreign_key 'caffeinate_campaign_subscriptions', 'caffeinate_campaigns'
  add_foreign_key 'caffeinate_mailings', 'caffeinate_campaign_subscriptions'
end
