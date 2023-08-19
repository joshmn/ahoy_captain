# frozen_string_literal: true

class AhoyCaptain::StickyNavComponent < ViewComponent::Base
  renders_one :realtime_update
  include ::AhoyCaptain::CompareMode
  include ::AhoyCaptain::RangeOptions
  include ::AhoyCaptain::Rangeable

  def filters
    @filters ||= ::AhoyCaptain::FilterParser.parse(request)
  end

  def custom_range_label
    if range.custom?
      [range.starts_at, range.ends_at].map { |date| date.strftime('%b %d, %Y') }.join("-")
    else
      "Custom Range"
    end
  end

  def tag_list_hidden?
    filters.values.map(&:values).flatten.size < ::AhoyCaptain::FilterParser::FILTER_MENU_MAX_SIZE
  end
end
