# frozen_string_literal: true

class AhoyCaptain::DropdownLinkComponent < ViewComponent::Base
  renders_many :options
  renders_one :header

  def initialize(title:, classes: nil)
    @title = title
    @classes = classes
  end

  def link_to(name, url, **options)
    self.with_option_content view_context.link_to name, url, options
  end

  private

  attr_reader :title, :classes
end
