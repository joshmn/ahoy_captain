module AhoyCaptain
  module Tables
    module Rows
      class RowComponent < ViewComponent::Base
        def initialize(table:, item:)
          @table = table
          @item = item
        end

        def progress_bar(value, max, label)
          items = []
          items << view_context.content_tag(:progress, "", class: "progress-primary bg-base-100 h-8 grow", value: value, max: max)
          items << view_context.content_tag(:span, class: "grow text-elipsis overflow-hidden absolute left-4 bottom-3 h-8 text-primary-content") do
            label
          end

          items.join.html_safe
        end

        def item(value = nil, &block)
          view_context.content_tag(:span, class: "w-8 ml-8 text-right ") do
            if value
              value
            else
              capture(&block)
            end
          end
        end

        def percent_total(item)
          '%.1f' % ((item.unit_amount.to_i * 1.0 / total)*100.0)
        end

        def tooltip(value)
          AhoyCaptain::TooltipComponent.new(amount: value).render_in(self)
        end
      end
    end
  end
end
