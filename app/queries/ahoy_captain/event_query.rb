module AhoyCaptain
  class EventQuery < ApplicationQuery
    include Rangeable

    def build
      entry_pages = ransack_params_for(:event).select { |k,v| k.start_with?("entry_page") }
      exit_pages = ransack_params_for(:event).select { |k,v| k.start_with?("exit_page") }

      event = AhoyCaptain.event
      shared_context = Ransack::Context.for(event)

      search_parents = event.ransack(
        ransack_params_for(:event).reject { |k,v| k.start_with?("visit_") }, context: shared_context
      )

      visit_params = ransack_params_for(:visit).reject { |k,v| k.start_with?("event_") || k.start_with?("events_") }.transform_keys { |key| "visit_#{key}" }
      search_children = AhoyCaptain.visit.ransack(
        visit_params, context: shared_context
      )
      shared_conditions = [search_parents, search_children].map { |search|
        Ransack::Visitor.new.accept(search.base)
      }

      joined = AhoyCaptain.event.joins(shared_context.join_sources)

      if entry_pages.values.any?(&:present?) || params[:controller].include?("entry_pages")
        joined = joined.with_entry_pages
      end

      if exit_pages.values.any?(&:present?) || params[:controller].include?("exit_pages")
        joined = joined.with_exit_pages
      end

      joined.where(shared_conditions.reduce(&:and))
    end
  end
end
