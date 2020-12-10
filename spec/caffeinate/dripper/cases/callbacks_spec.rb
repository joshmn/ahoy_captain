# frozen_string_literal: true

require 'rails_helper'

describe ::Caffeinate::Dripper::Callbacks do
  class CallbacksTestOneDripper < ::Caffeinate::Dripper::Base
    self.campaign = :callbacks_test_one

    on_subscribe do
      @ran = true
    end
  end

  class CallbacksTestTwoDripper < ::Caffeinate::Dripper::Base
    self.campaign = :callbacks_test_two

    on_subscribe do
      @ran = true
    end

    on_subscribe do
      @ran_two = true
    end
  end

  let!(:campaign_one) { create(:caffeinate_campaign, slug: :callbacks_test_one) }
  let!(:campaign_two) { create(:caffeinate_campaign, slug: :callbacks_test_two) }

  context '.on_subscribe' do
    it 'works' do
      company = create(:company)
      expect(CallbacksTestOneDripper.on_subscribe_blocks.size).to eq(1)
      expect(CallbacksTestOneDripper.instance_variable_get(:@ran)).to be_falsey
      campaign_one.subscribe(company)
      expect(CallbacksTestOneDripper.instance_variable_get(:@ran)).to be_truthy

      expect(CallbacksTestTwoDripper.on_subscribe_blocks.size).to eq(2)
      expect(CallbacksTestTwoDripper.instance_variable_get(:@ran)).to be_falsey
      expect(CallbacksTestTwoDripper.instance_variable_get(:@ran_two)).to be_falsey
      campaign_two.subscribe(company)
      expect(CallbacksTestTwoDripper.instance_variable_get(:@ran)).to be_truthy
      expect(CallbacksTestTwoDripper.instance_variable_get(:@ran_two)).to be_truthy
    end
  end

  let(:campaign) { create(:caffeinate_campaign, :with_dripper) }
  let(:dripper) { campaign.to_dripper }
  let(:company) { create(:company) }
  let(:subscription) { campaign.subscribe(company) }
  let(:mailing) { subscription.caffeinate_mailings.first }

  context '.before_perform' do
    before do
      dripper.cattr_accessor :before_performing
    end

    it 'runs before dripper#process! is called' do
      dripper.before_perform do
        dripper.before_performing = 1
      end
      expect(dripper.before_performing).to be_nil
      dripper.perform!
      expect(dripper.before_performing).to eq(1)
    end

    it 'yields a Dripper' do
      dripper.before_perform do |*args|
        dripper.before_performing = args
      end
      dripper.perform!
      args = dripper.before_performing
      expect(args.size).to be(1)
      expect(args[0]).to be_a(Caffeinate::Dripper::Base)
      expect(args[0]).to be_a(dripper)
    end
  end

  context '.on_process' do
    before do
      dripper.drip :hello, mailer_class: "ArgumentMailer", delay: 0.hours
      company = create(:company)
      campaign.subscribe(company)
      dripper.cattr_accessor :on_performing
    end

    it 'runs when dripper#process! is called' do
      dripper.on_perform do
        dripper.on_performing = 1
      end
      expect(dripper.on_performing).to be_nil
      campaign.to_dripper.perform!
      expect(dripper.on_performing).to eq(1)
    end

    it 'yields a Caffeinate::Dripper, Mailing [Array]' do
      dripper.on_perform do |*args|
        dripper.on_performing = args
      end
      dripper.perform!
      args = dripper.on_performing
      expect(args.size).to be(2)
      expect(args[0]).to be_a(Caffeinate::Dripper::Base)
      expect(args[0]).to be_a(dripper)
      expect(args[1]).to be_a(ActiveRecord::Relation)
      expect(args[1].name).to eq('Caffeinate::Mailing')
    end
  end

  context '.after_perform' do
    before do
      dripper.drip :hello, mailer_class: "ArgumentMailer", delay: 0.hours
      company = create(:company)
      campaign.subscribe(company)
      dripper.cattr_accessor :after_performing
    end

    it 'runs after dripper#process! is called' do
      dripper.after_perform do
        dripper.after_performing = 1
      end
      expect(dripper.after_perform_blocks.size).to eq(1)
      expect(dripper.after_performing).to be_nil
      campaign.to_dripper.perform!
      expect(dripper.after_performing).to eq(1)
    end

    it 'yields a Caffeinate::Dripper, Mailing [Array]' do
      dripper.after_perform do |*args|
        dripper.after_performing = args
      end
      expect(dripper.after_performing).to be_nil
      campaign.to_dripper.perform!
      expect(dripper.after_performing.size).to eq(1)
      expect(dripper.after_performing.first).to be_a(dripper)
    end
  end

  context '.before_drip' do
    it 'runs before drip has called the mailer' do

    end

    it 'yields a Drip, Mailing' do

    end
  end

  context '.before_send' do
    before do
      dripper.cattr_accessor :before_sending
    end

    let(:mail) { Mail.from_source("Date: Fri, 28 Sep 2018 11:08:55 -0700\r\nTo: a@example.com\r\nMime-Version: 1.0\r\nContent-Type: text/plain\r\nContent-Transfer-Encoding: 7bit\r\n\r\nHello!") }
    it 'does not run if caffeinate_mailing is false' do
      dripper.before_send do
        dripper.before_sending = 1
      end
      ::Caffeinate::ActionMailer::Interceptor.delivering_email(mail)
      expect(dripper.before_sending).to_not eq(1)
    end

    it 'runs if caffeinate_mailing is present' do
      dripper.before_send do
        dripper.before_sending = 1
      end
      dripper.drip :hello, mailer_class: "ArgumentMailer", delay: 0.hours
      company = create(:company)
      subscription = campaign.subscribe(company)
      mail.caffeinate_mailing = subscription.caffeinate_mailings.first
      ::Caffeinate::ActionMailer::Interceptor.delivering_email(mail)
      expect(dripper.before_sending).to eq(1)
    end

    it 'yields a Mailing, Mail::Message' do
      dripper.before_send do |*args|
        dripper.before_sending = args
      end
      dripper.drip :hello, mailer_class: "ArgumentMailer", delay: 0.hours
      company = create(:company)
      subscription = campaign.subscribe(company)
      mail.caffeinate_mailing = subscription.caffeinate_mailings.first
      ::Caffeinate::ActionMailer::Interceptor.delivering_email(mail)
      expect(dripper.before_sending.size).to eq(2)
      expect(dripper.before_sending[0]).to eq(mail.caffeinate_mailing)
      expect(dripper.before_sending[1]).to eq(mail)
    end
  end

  context '.after_send' do
    before do
      dripper.cattr_accessor :after_sending
    end

    let(:mail) { Mail.from_source("Date: Fri, 28 Sep 2018 11:08:55 -0700\r\nTo: a@example.com\r\nMime-Version: 1.0\r\nContent-Type: text/plain\r\nContent-Transfer-Encoding: 7bit\r\n\r\nHello!") }
    it 'does not run if caffeinate_mailing is false' do
      dripper.after_send do
        dripper.after_sending = 1
      end
      ::Caffeinate::ActionMailer::Observer.delivered_email(mail)
      expect(dripper.after_sending).to be_nil
    end

    it 'runs if caffeinate_mailing is present' do
      dripper.after_send do
        dripper.after_sending = 1
      end
      dripper.drip :hello, mailer_class: "ArgumentMailer", delay: 0.hours
      company = create(:company)
      subscription = campaign.subscribe(company)
      mail.caffeinate_mailing = subscription.caffeinate_mailings.first
      ::Caffeinate::ActionMailer::Observer.delivered_email(mail)
      expect(dripper.after_sending).to eq(1)
    end

    it 'yields a Mailing, Mail::Message' do
      dripper.after_send do |*args|
        dripper.after_sending = args
      end
      dripper.drip :hello, mailer_class: "ArgumentMailer", delay: 0.hours
      company = create(:company)
      subscription = campaign.subscribe(company)
      mail.caffeinate_mailing = subscription.caffeinate_mailings.first
      ::Caffeinate::ActionMailer::Observer.delivered_email(mail)
      expect(dripper.after_sending.size).to eq(2)
      expect(dripper.after_sending[0]).to eq(mail.caffeinate_mailing)
      expect(dripper.after_sending[1]).to eq(mail)
    end
  end

  context '.on_end' do
    before do
      dripper.cattr_accessor :on_ending
    end
    it 'runs after Caffeinate::CampaignSubscription#end! has been called' do
      dripper.on_end do
        dripper.on_ending = 1
      end
      expect(dripper.on_ending).to be_nil
      subscription.end!
      expect(dripper.on_ending).to be(1)
    end

    it 'yields a CampaignSubscriber' do
      dripper.on_end do |*args|
        dripper.on_ending = args
      end
      expect(dripper.on_ending).to be_nil
      subscription.end!
      expect(dripper.on_ending.first).to eq(subscription)
    end
  end

  context '.on_unsubscribe' do
    before do
      dripper.cattr_accessor :on_unsubscribing
    end

    it 'runs after before Mailing#unsubscribe! has been called' do
      dripper.on_unsubscribe do
        dripper.on_unsubscribing = 1
      end
      expect(dripper.on_unsubscribing).to be_nil
      subscription.unsubscribe!
      expect(dripper.on_unsubscribing).to be(1)
    end

    it 'yields a CampaignSubscriber' do
      dripper.on_unsubscribe do |*args|
        dripper.on_unsubscribing = args
      end
      expect(dripper.on_unsubscribing).to be_nil
      subscription.unsubscribe!
      expect(dripper.on_unsubscribing.size).to be(1)
      expect(dripper.on_unsubscribing.first).to be(subscription)
    end
  end

  context '.on_skip' do
    before do
      dripper.cattr_accessor :on_skipping
      dripper.drip :hello, mailer_class: "ArgumentMailer", delay: 0.hours
      company = create(:company)
      campaign.subscribe(company)
    end
    it 'runs after before Mailing#skip! has been called' do
      dripper.on_skip do
        dripper.on_skipping = 1
      end
      expect(dripper.on_skipping).to be_nil
      mailing.skip!
      expect(dripper.on_skipping).to be(1)
    end

    it 'yields a CampaignSubscriber' do
      dripper.on_skip do |*args|
        dripper.on_skipping = args
      end

      expect(dripper.on_skipping).to be_nil
      mailing.skip!
      expect(dripper.on_skipping.size).to be(1)
      expect(dripper.on_skipping.first).to be(mailing)
    end
  end
end
