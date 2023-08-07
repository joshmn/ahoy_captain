# frozen_string_literal: true

class AhoyCaptain::TileComponent < ViewComponent::Base
  renders_one :statistic_display
  renders_one :display_links
  renders_one :details_cta

  def initialize(title: nil, wide: false)
    @title = title
    @wide = wide
  end

  private

  attr_reader :title, :wide
end
