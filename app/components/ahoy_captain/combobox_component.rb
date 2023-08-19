module AhoyCaptain
  class ComboboxComponent < ViewComponent::Base
    def initialize(name:, multiple: false, disabled: false, column:, url:, value: [], select_html: {})
      @name = name
      @multiple = multiple
      @column = column
      @url = url
      @value = Array(value)
      @select_html = select_html
      @disabled = disabled
    end
  end
end
