# frozen_string_literal: true

class AhoyCaptain::DropdownComponent < ViewComponent::Base
  renders_many :options

  def initialize(title:)
    @title = title
  end

  private

  attr_reader :title
end
