class AhoyCaptain::TooltipComponent < ViewComponent::Base
  def initialize(amount:)
    @amount = amount
  end

  def abbreviate
    
    if amount >= 1000
      number_to_human(amount, format: '%n%u', precision: 2, units: { thousand: 'k', million: 'm', billion: 'b' })
    else
      amount.to_s
    end
  end

  private

  attr_reader :amount
end