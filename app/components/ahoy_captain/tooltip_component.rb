class AhoyCaptain::TooltipComponent < ViewComponent::Base
  def initialize(item:)
      @item = item
  end

  def abbreviate
      number = item.unit_amount
      if number >= 1000
        number_to_human(number, format: '%n%u', precision: 2, units: { thousand: 'k', million: 'm', billion: 'b' })
      else
        number.to_s
      end
  end

    private

    attr_reader :item
end