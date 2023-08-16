module AhoyCaptain
  class ComboboxComponent < ViewComponent::Base
    def initialize(name:, multiple: false, column:, url:, value: [])
      @name = name
      @multiple = multiple
      @column = column
      @url = url
      @value = value
    end
  end
end
