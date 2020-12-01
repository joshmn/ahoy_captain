# frozen_string_literal: true

require 'rails_helper'

describe Caffeinate::Dripper::Base do
  let!(:campaign) { create(:caffeinate_campaign, slug: 'funky_dripper') }
  class FunkyDripper < Caffeinate::Dripper::Base
self.campaign = :funky_dripper

    drip :test_1, delay: 0.hours, mailer_class: 'Test'
    drip :test_2, delay: 0.hours, mailer_class: 'Test'
  end

  context 'drips' do
    it 'should be 2' do
      expect(FunkyDripper.drips.count).to eq(2)
    end
  end

  context '.inffered_mailer_class' do
    it 'is nil if there is no defined class' do
      class BaseInferredDripper < Caffeinate::Dripper::Base; end
      expect(BaseInferredDripper.inferred_mailer_class).to be_nil
    end
    it 'is nil if there is no matching class' do
      class BaseMatchingMailer < ::ActionMailer::Base; end
      class BaseMatchingInferredDripper < Caffeinate::Dripper::Base; end
      expect(BaseMatchingInferredDripper.inferred_mailer_class).to be_nil
    end
    it 'is nil if there is no matching class that inherits from ActionMailer::Base' do
      class BaseInferredObjectMailer; end
      class BaseInferredObjectDripper < Caffeinate::Dripper::Base; end
      expect(BaseInferredObjectDripper.inferred_mailer_class).to be_nil
    end
    it 'is a string if there is a matching mailer class' do
      class BaseInferredRealMailer < ::ActionMailer::Base; end
      class BaseInferredRealDripper < Caffeinate::Dripper::Base; end
      expect(BaseInferredRealDripper.inferred_mailer_class).to be_present
    end
  end
end
