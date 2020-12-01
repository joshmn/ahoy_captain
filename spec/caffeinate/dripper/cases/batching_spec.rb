# frozen_string_literal: true

require 'rails_helper'

describe ::Caffeinate::Dripper::Batching do
  class BatchingDripper < ::Caffeinate::Dripper::Base; end

  context '.batch_size' do
    it 'equals config.batch_size by default' do
      expect(BatchingDripper.batch_size).to eq(::Caffeinate.config.batch_size)
    end
  end

  context '.batch_size=' do
    it 'sets the batch_size' do
      original = BatchingDripper.batch_size
      expect do
        BatchingDripper.batch_size = 5
      end.to change(BatchingDripper, :batch_size).to(5)
      BatchingDripper.batch_size = original
    end
  end
end
