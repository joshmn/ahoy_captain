# frozen_string_literal: true

class AhoyCaptain::TileComponent < ViewComponent::Base
  renders_one :statistic_display
  renders_one :display_links
  renders_one :details_cta

  def initialize(title: nil, wide: false)
    @title = title
    @wide = wide
  end

  def tile_class
    themes = ["dark", "synthwave", "forest", "halloween", "black", "luxury", "dracula", "business", "night", "coffee"]
    if AhoyCaptain.config.theme.in?(themes)
      "bg-gray-800"
    else
      "bg-base-200"
    end
  end

  private

  attr_reader :title, :wide
end
