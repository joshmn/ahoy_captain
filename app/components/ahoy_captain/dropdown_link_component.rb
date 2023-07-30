# frozen_string_literal: true

class AhoyCaptain::DropdownLinkComponent < ViewComponent::Base
  renders_many :options
  renders_one :header

  def initialize(title:, classes: nil)
    @title = title
    @classes = classes
  end

  private

  attr_reader :title, :classes
end
