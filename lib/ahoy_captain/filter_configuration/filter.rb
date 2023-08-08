module AhoyCaptain
  class FilterConfiguration
    class Filter
      attr_reader :column, :label, :url, :predicates, :multiple, :position

      def initialize(label:, column:, url:, predicates: [:in, :not_in], multiple: true, position: nil)
        @column = column
        @label = label
        @url = url
        @predicates = predicates
        @multiple = multiple
        @position = position
      end
    end
  end
end
