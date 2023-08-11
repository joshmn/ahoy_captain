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

    comparison_mode.label
  end

  def render?
    comparison_mode.enabled?
  end

  def options_for_option
    [
      (link_to "Disable Comparison", AhoyCaptain::Engine.routes.url_helpers.root_path(**helpers.search_params.merge(comparison: false))),
      (link_to "Previous period", AhoyCaptain::Engine.routes.url_helpers.root_path(**helpers.search_params.merge(comparison: :previous)), class: selected(:previous, :true)),
      (link_to "Year-over-year", AhoyCaptain::Engine.routes.url_helpers.root_path(**helpers.search_params.merge(comparison: :year)), class: selected(:year)),
      (link_to "Custom period", "javascript:customComparisonModal.showModal()", class: selected(:custom)),

    ].join.html_safe
  end

  private

  def selected(*types)
    return "font-bold" if comparison_mode.type.in?(types)

    nil
  end
end
