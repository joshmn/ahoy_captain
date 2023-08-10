# frozen_string_literal: true

class AhoyCaptain::ComparisonLinkComponent < AhoyCaptain::DropdownLinkComponent
  include ::AhoyCaptain::CompareMode
  include ::AhoyCaptain::RangeOptions
  include ::AhoyCaptain::Rangeable

  def initialize(title: "", classes: "btn btn-sm btn-base-100 no-underline hover:bg-base-100")
    @classes = classes
  end

  # cheating
  def title
    self.with_option_content(options_for_option)

    comparison_label
  end

  def render?
    comparison_label.present?
  end

  def options_for_option
    [(link_to "Disable Comparison", AhoyCaptain::Engine.routes.url_helpers.root_path(**helpers.search_params.except('comparison')))].join.html_safe
  end
end
