module AhoyCaptain
  class FilterParser
    class Item
      attr_accessor :name, :column, :description, :values, :predicate, :url, :modal

      def title
        column.titleize
      end
    end

    PREDICATES = {
      _eq: 'equals',
      _not_eq: 'not equals',
      _cont: 'contains',
      _in: 'in',
      _not_in: 'not in',
    }

    PREDICATE_REGEX = %r{(#{Regexp.union(PREDICATES.keys.map(&:to_s))})$}

    COLUMN_TO_MODAL = {
      page: [:entry_page, :exit_page, :route],
      country: [:country, :region, :city],
      screen: [:device_type],
      os: [:os, :os_version],
      utm: [:utm_source, :utm_medium, :utm_term, :utm_content, :utm_campaign]
    }

    def self.parse(request)
      new(request).tap do |instance|
        instance.parse
        instance
      end
    end

    delegate_missing_to :@items

    def initialize(request)
      @request = request
      @params = @request.params
      @filter_params = @request.params[:q] || {}
      @items = {}
    end

    def parse
      @filter_params.each do |key, values|
        item = Item.new
        item.predicate = key.scan(PREDICATE_REGEX).flatten.first
        item.column = key.delete_suffix(item.predicate)
        modal_name = COLUMN_TO_MODAL.detect { |_key, values| values.include?(item.column.to_sym) }[0]
        item.modal = "#{modal_name}Modal"
        item.description = "#{item.column.titleize} #{PREDICATES[item.predicate.to_sym]} #{values.to_sentence(last_word_connector: " or ")}"
        item.url = build_url(key, values)
        item.values = values
        @items[key] = item
      end
    end

    def build_url(name, values)
      search_params = @request.query_parameters.deep_dup
      if search_params["q"][name].is_a?(Array)
        search_params["q"][name] = search_params["q"][name] - Array(values)
      else
        search_params["q"].delete(name)
      end

      @request.path + "?" + search_params.to_query
    end

  end
end
