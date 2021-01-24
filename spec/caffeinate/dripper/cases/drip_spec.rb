# frozen_string_literal: true

require 'rails_helper'

describe ::Caffeinate::Dripper::Drip do
  class DripDripper < ::Caffeinate::Dripper::Base
    drip :test, delay: 0.hours, step: 1, mailer_class: 'CoolMailer'
  end

  describe '.drip' do
    it 'has a drips count' do
      expect(DripDripper.drips.size).to eq(1)
    end

    it 'registers a drip with valid arguments' do
      expect(DripDripper.drips.first.options).to eq({ delay: 0.hours, step: 1, mailer_class: 'CoolMailer', using: nil })
    end
  end

  context 'strings as keys' do
    it 'converts to symbols' do
      DripDripper.drip 'test_two', 'delay': 0.hours, 'step': 1, 'mailer_class': 'CoolMailer'
      expect(DripDripper.drip_collection.for(:test_two).options).to eq({ delay: 0.hours, step: 1, mailer_class: 'CoolMailer', using: nil })
    end
  end

  context 'no delay' do
    it 'raises ArgumentError' do
      expect do
        DripDripper.drip :welcome
      end.to raise_error(ArgumentError)
    end
  end

  context 'at: option' do
    it 'creates the drip at the time' do
      DripDripper.drip :welcome, delay: 3.days, at: "6:13:04 PM America/New_York", mailer_class: 'Fun'
      time = DripDripper.drip_collection.for(:welcome).send_at.to_time
      expect(time.min).to eq(13)
      expect(time.sec).to eq(4)
      expect(time.hour).to eq(18)
    end
  end

  context 'on: option' do
    context 'is a block' do
      it 'creates the drip at the date' do
        Timecop.freeze do
          DripDripper.drip :welcome, on: -> { 5.days.from_now }, mailer_class: 'Fun'
          time = DripDripper.drip_collection.for(:welcome).send_at
          expect(time).to eq(5.days.from_now)
        end
      end
    end

    context 'is a symbol' do
      it 'creates a time at the date' do
        Timecop.freeze do
          DripDripper.drip :pokemon, on: :generate_date, mailer_class: "Funk"
          DripDripper.class_eval do
            def generate_date(_drip, _mailing)
              2.days.from_now
            end
          end
          time = DripDripper.drip_collection.for(:pokemon).send_at
          expect(time).to eq(2.days.from_now)
        end
      end
    end
  end

  describe ::Caffeinate::OptionEvaluator do
    context 'when symbol' do
      class RealFakeDripper
        def generate(drip, mailing)
          "I got called"
        end
        def generate_drip(drip, mailing)
          drip
        end
        def generate_mailing(drip, mailing)
          mailing
        end
      end
      it 'calls @thing on the dripper instance' do
        drip = ::Caffeinate::Drip.new(RealFakeDripper, :fake, mailer_class: "PotatoMailer", at: :generate)
        mailing = build_stubbed(:caffeinate_mailing)
        evaluator = ::Caffeinate::OptionEvaluator.new(:generate, drip, mailing)
        expect(evaluator.call).to eq("I got called")
      end

      it 'sends drip as the first argument' do
        drip = ::Caffeinate::Drip.new(RealFakeDripper, :fake, mailer_class: "PotatoMailer", at: :generate_drip)
        mailing = build_stubbed(:caffeinate_mailing)
        evaluator = ::Caffeinate::OptionEvaluator.new(:generate_drip, drip, mailing)
        expect(evaluator.call).to eq(drip)
      end

      it 'sends mailing as the second argument' do
        drip = ::Caffeinate::Drip.new(RealFakeDripper, :fake, mailer_class: "PotatoMailer", at: :generate_mailing)
        mailing = build_stubbed(:caffeinate_mailing)
        evaluator = ::Caffeinate::OptionEvaluator.new(:generate_mailing, drip, mailing)
        expect(evaluator.call).to eq(mailing)
      end
    end

    context 'when string' do
      it 'gets parsed into Time' do
        drip = ::Caffeinate::Drip.new(RealFakeDripper, :fake, mailer_class: "PotatoMailer")
        mailing = build_stubbed(:caffeinate_mailing)
        evaluator = ::Caffeinate::OptionEvaluator.new('January 21, 2021', drip, mailing)
        expect(evaluator.call).to be_a(Time)
      end
    end

    context 'when block' do
      it 'execs inside the mailing' do
        drip = ::Caffeinate::Drip.new(RealFakeDripper, :fake, mailer_class: "PotatoMailer")
        mailing = build_stubbed(:caffeinate_mailing)
        proc = Proc.new { self }
        evaluator = ::Caffeinate::OptionEvaluator.new(proc, drip, mailing)
        expect(evaluator.call).to eq(mailing)
      end
    end
  end
end
