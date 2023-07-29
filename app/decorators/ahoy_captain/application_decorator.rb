module AhoyCaptain
  class ApplicationDecorator
    attr_reader :object

    def initialize(object)
      @object = object
    end
  end
end
