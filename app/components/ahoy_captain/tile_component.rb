# frozen_string_literal: true

class AhoyCaptain::TileComponent < ViewComponent::Base
  renders_one :statistic_display
  renders_one :display_links
  renders_one :details_cta

  def initialize(title: nil, wide: false, classes: "p-8 mx-4")
    @classes = classes
    @title = title
    @wide = wide
  end

  def link_to(name, url, **options)
    options[:class] = "inline-block h-5 font-semibold"
    options[:data] ||= {}
    options[:data].merge!(controller: "frame-link")
    view_context.link_to name, url, **options
  end

  private

  attr_reader :title, :wide
end
