class AhoyCaptain::TileComponent < ViewComponent::Base
  renders_one :statistic_display
  renders_one :display_links
  renders_one :details_cta

  def initialize(title:)
    @title = title
  end

  private

  attr_reader :title
end