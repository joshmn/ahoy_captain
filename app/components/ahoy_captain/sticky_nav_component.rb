# frozen_string_literal: true

class AhoyCaptain::StickyNavComponent < ViewComponent::Base
  renders_one :realtime_update

  def filters
    @filters ||= ::AhoyCaptain::FilterParser.parse(request)
  end

  def tag_list_visible?
    filters.values.map(&:values).flatten.size < 3
  end
end
