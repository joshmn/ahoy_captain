module AhoyCaptain
  class SourcesController < ApplicationController
    include Limitable

    before_action do
      if Widget.disabled?(:sources)
        raise Widget::WidgetDisabled.new("Widget disabled", :sources)
      end
    end

    def index
      @sources = cached(:sources) do
        visit_query.within_range.select("substring(referring_domain from '(?:.*://)?(?:www\.)?([^/?]*)') as referring_domain, count(substring(referring_domain from '(?:.*://)?(?:www\.)?([^/?]*)')) as count, sum(count(substring(referring_domain from '(?:.*://)?(?:www\.)?([^/?]*)'))) OVER() as total_count")
                   .where.not(referring_domain: nil)
                   .group("substring(referring_domain from '(?:.*://)?(?:www\.)?([^/?]*)')")
                   .order(Arel.sql "count(substring(referring_domain from '(?:.*://)?(?:www\.)?([^/?]*)')) desc")
                   .limit(limit)

      end

      @sources = @sources.map { |source| AhoyCaptain::SourceDecorator.new(source) }

      render json: @sources
    end
  end

end
