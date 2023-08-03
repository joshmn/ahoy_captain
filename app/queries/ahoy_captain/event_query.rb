module AhoyCaptain
  class EventQuery < ApplicationQuery
    include Rangeable

    def build
      shared_context = Ransack::Context.for(AhoyCaptain.event)

      search_parents = AhoyCaptain.event.ransack(
        ransack_params_for(:event).reject { |k,v| k.start_with?("visit_") }, context: shared_context
      )
      search_children = AhoyCaptain.visit.ransack(
        ransack_params_for(:visit).reject { |k,v| k.start_with?("event_") || k.start_with?("events_") }.transform_keys { |key| "visit_#{key}" }, context: shared_context
      )

      shared_conditions = [search_parents, search_children].map { |search|
        Ransack::Visitor.new.accept(search.base)
      }

      AhoyCaptain.event.joins(shared_context.join_sources)
                 .where(shared_conditions.reduce(&:or))
    end
  end
end
