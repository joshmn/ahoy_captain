# frozen_string_literal: true

class AhoyCaptain::Filter::TagComponent < ViewComponent::Base
  def initialize(tag_item:)
    @tag_item = tag_item
  end

  private 
  attr_reader :tag_item

  def modal
    tag_item.modal
  end
end
