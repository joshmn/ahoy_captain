module AhoyCaptain
  class SourceQuery < ApplicationQuery
    def build
      visit_query.select("substring(referring_domain from '(?:.*://)?(?:www\.)?([^/?]*)') as referring_domain, count(substring(referring_domain from '(?:.*://)?(?:www\.)?([^/?]*)')) as count, sum(count(substring(referring_domain from '(?:.*://)?(?:www\.)?([^/?]*)'))) OVER() as total_count")
                 .where.not(referring_domain: nil)
                 .group("substring(referring_domain from '(?:.*://)?(?:www\.)?([^/?]*)')")
                 .order(Arel.sql "count(substring(referring_domain from '(?:.*://)?(?:www\.)?([^/?]*)')) desc")
    end
  end
end
