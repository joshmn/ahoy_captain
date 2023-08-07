module AhoyCaptain
  class FilterParser
    class Item
      attr_accessor :name, :column, :description, :values, :predicate, :url, :modal

      def title
        column.titleize
      end
    end

    PREDICATES_LABELS = {
      eq: 'equals',
      not_eq: 'not equals',
      cont: 'contains',
      in: 'in',
      not_in: 'not in',
    }

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

        item.values = Array(values)
        item.predicate = Ransack::Predicate.detect_and_strip_from_string!(key.dup)
        item.column = key.delete_suffix("_#{item.predicate}")
        modal_name = COLUMN_TO_MODAL.detect { |_key, values| values.include?(item.column.to_sym) }[0]
        item.modal = "#{modal_name}Modal"
        item.description = "#{item.column.titleize} #{PREDICATES_LABELS[item.predicate.to_sym]} #{item.values.to_sentence(last_word_connector: " or ")}"
        item.url = build_url(key, values)
        @items[key] = item
      end

      if goal_id = @params[:goal_id]
        @items[:goal_id] = Item.new.tap do |item|
          item.values = [goal_id]
          item.predicate = "?"
          item.column = "Goal"
          item.modal = nil
          goal = AhoyCaptain.config.goals[goal_id.to_sym]

          item.description = "Goal is #{goal.title}"
          item.url = @request.path + "?" + @request.query_parameters.deep_dup.except(:goal_id).to_query
        end
      end
      @items
    end

    private

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
