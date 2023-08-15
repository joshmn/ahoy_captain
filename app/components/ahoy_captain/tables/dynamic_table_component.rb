module AhoyCaptain
  module Tables
    class DynamicTableComponent < ViewComponent::Base
      class TableDefinition
        attr_reader :rows
        class Row
          attr_reader :attribute, :view_context
          attr_reader :item
          def initialize(attribute, options = {}, &block)
            @attribute = attribute
            @options = options
            @block = block
            @view_context = nil
          end

          def render(item, view_context)
            @view_context = view_context
            @item = item
            if @options[:type] == :progress_bar
              progress_bar(item)
            else
              if @block
                column(@block.call(item))
              else
                column(item.public_send(attribute).presence)
              end
            end

          end

          def header
            @options[:title] || @attribute.to_s.titleize
          end

          def link_to(*args)
            @view_context.link_to(*args)
          end

          def request
            @view_context.request
          end

          def h
            @view_context.helpers
          end

          def search_params
            @view_context.search_params
          end

          # needed for tricky instance_eval with blocks and view_context
          def method_missing(method, *args, &block)
            if klass.respond_to?(method)
              klass.send(method, *args, &block)
            else
              @item.send method, *args, &block
            end
          end

          def klass
            @options[:klass]
          end

          def progress_bar(item)
            @item = item
            value = if @options[:value]
                      build_option(item, @options[:value]).to_s
                    else
                      item.public_send(@attribute)
                    end

            max = build_option(item, @options[:max]).to_s
            label = if @block
                      instance_eval(&@block)
                    else
                      item.public_send(@attribute)
                    end.to_s

            items = []
            items << view_context.content_tag(:progress, "", class: "progress-primary bg-base-100 h-8 grow", value: value, max: max)
            items << view_context.content_tag(:span, class: "grow text-elipsis overflow-hidden absolute left-4 bottom-3 h-8 text-primary-content") do
              label
            end

            items.join.html_safe
          end

          def build_option(item, value)
            if value.is_a?(Symbol)
              item.public_send(value)
            else
              value
            end
          end

          def column(value = nil, &block)
            view_context.content_tag(:span, class: "w-8 ml-8 text-right") do
              if value
                if @options[:formatter]
                  if respond_to?(@options[:formatter])
                    public_send(@options[:formatter], value)
                  else
                    view_context.public_send(@options[:formatter], value)
                  end
                else
                  value.to_s
                end
              else
                view_context.capture(&block).to_s
              end
            end
          end

          def number_to_human(amount)
            tooltip(amount) do
              view_context.number_to_human(amount, format: '%n%u', precision: 2, units: { thousand: 'k', million: 'm', billion: 'b' })
            end
          end

          def percent_total(item)
            '%.1f' % ((item.unit_amount.to_i * 1.0 / total)*100.0)
          end

          def tooltip(value)
            AhoyCaptain::TooltipComponent.new(amount: value).render_in(view_context)
          end
        end

        def initialize(klass)
          @klass = klass
          @rows = []
        end

        def column(key = nil, options = {}, &block)
          options[:klass] = @klass
          @rows << Row.new(key, options, &block)

          self
        end

        def progress_bar(*args, &block)
          options = args.extract_options!
          options.assert_valid_keys(:value, :max, :title)
          options[:klass] = @klass

          @rows << Row.new(args[0], options.merge(type: :progress_bar), &block)

          self
        end

        def number(key = nil, options = {}, &block)
          options[:klass] = @klass

          @rows << Row.new(key, options.merge(formatter: :number_to_human), &block)

          self
        end

        def percent(key = nil, options = {}, &block)
          options[:klass] = @klass

          @rows << Row.new(key, options.merge(formatter: :number_to_percentage), &block)

          self
        end

        def row(item, view_context)
          items = []
          @rows.each do |row|
            items << row.render(item, view_context)
          end
          items.join.html_safe
        end
      end

      def self.build(klass, options = {}, &block)
        if options.key?(:fixed_height)
          options[:header_options] = { fixed_height: options.delete(:fixed_height) }
        end
        table = TableDefinition.new(klass).instance_exec(&block)
        new(klass, table, options)
      end

      def initialize(klass, table, options = {})
        @klass = klass
        @table = table
        @options = options
      end

      def for(item)
        @item = item
        self
      end

      def row(item, view_context)
        @table.row(item, view_context)
      end

      def headers
        HeaderComponent.new(@table.rows.map.with_index { |row, index| { label: row.header, grow: index.zero? } }, @options[:header_options] || {})
      end
    end
  end
end
