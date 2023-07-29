# frozen_string_literal: true

class AhoyCaptain::DropdownButtonComponent < ViewComponent::Base
  renders_many :options
  renders_one :header_icon

  def initialize(title:)
    @title = title
  end

  private

  attr_reader :title
end
