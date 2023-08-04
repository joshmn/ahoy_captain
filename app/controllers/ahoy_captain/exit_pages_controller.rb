module AhoyCaptain
  class ExitPagesController < ApplicationController
    include Limitable

    before_action do
      if Widget.disabled?(:exit_pages)
        raise Widget::WidgetDisabled.new("Widget disabled", :pages)
      end
    end

    def index
      results = cached(:exit_pages) do
        ExitPagesQuery.call(params)
                      .limit(limit)
      end
      @pages = paginate(results).map { |page| ExitPageDecorator.new(page, self) }
    end
  end
end
