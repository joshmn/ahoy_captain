# frozen_string_literal: true

class AhoyCaptain::Filter::TagComponent < ViewComponent::Base
  def initialize(tag_item:)
    @tag_item = tag_item
  end
end
