# frozen_string_literal: true

require 'rails_helper'

describe Caffeinate::Dripper::Inferences do
  context '.infered_mailer_class' do
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

  context '.infered_campaign_slug' do
    it 'deletes the Dripper suffix' do
      class BaseInferredDripper < Caffeinate::Dripper::Base; end
      expect(BaseInferredDripper.inferred_campaign_slug).to_not end_with("Dripper")
    end

    it 'converts to underscore' do
      class BaseInferredDripper < Caffeinate::Dripper::Base; end
      expect(BaseInferredDripper.inferred_campaign_slug).to eq("base_inferred")
    end
  end
end
