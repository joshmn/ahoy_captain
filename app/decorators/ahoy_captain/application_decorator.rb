module AhoyCaptain
  class ApplicationDecorator
    attr_reader :object

    def initialize(object, context)
      @object = object
      @context = context
    end

    private

    def h
      @h ||= @context.view_context
    end

    def params
      h.params
    end

    def search_query(args = {})
      query = h.search_params.dup
      query[:q] ||= {}
      args.each { |k,v| query[:q]["#{k}"] = v }
      query.to_query
    end

    def frame_link(label, search)
      h.link_to(label, "#{AhoyCaptain::Engine.routes.url_helpers.root_path}?#{search}", data: { turbo_frame: "_top" }).html_safe
    end

    def request
      @context.request
    end
  end
end
