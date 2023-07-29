module AhoyCaptain
  class SourcesController < ApplicationController
    include Limitable

    before_action do
      if Widget.disabled?(:sources)
        raise Widget::WidgetDisabled.new("Widget disabled", :sources)
      end
    end

    def index
      results = cached(:sources) do
        visit_query.select("substring(referring_domain from '(?:.*://)?(?:www\.)?([^/?]*)') as referring_domain, count(substring(referring_domain from '(?:.*://)?(?:www\.)?([^/?]*)')) as count, sum(count(substring(referring_domain from '(?:.*://)?(?:www\.)?([^/?]*)'))) OVER() as total_count")
                   .where.not(referring_domain: nil)
                   .group("substring(referring_domain from '(?:.*://)?(?:www\.)?([^/?]*)')")
                   .order(Arel.sql "count(substring(referring_domain from '(?:.*://)?(?:www\.)?([^/?]*)')) desc")
                   .limit(limit)
      end

      @sources = paginate(results).map { |source| AhoyCaptain::SourceDecorator.new(source) }
    end
  end

end
