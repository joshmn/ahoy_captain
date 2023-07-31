module AhoyCaptain
  class VisitQuery < ApplicationQuery
    include Rangeable

    def build
      shared_context = Ransack::Context.for(AhoyCaptain.visit)

      search_parents = AhoyCaptain.visit.ransack(
        ransack_params_for(:visit).reject { |k,v| k.start_with?("events_") }, context: shared_context
      )
      search_children = AhoyCaptain.event.ransack(
        ransack_params_for(:event).reject { |k,v| k.start_with?("visit_") }.transform_keys { |key| "events_#{key}" }, context: shared_context
      )

      shared_conditions = [search_parents, search_children].map { |search|
        Ransack::Visitor.new.accept(search.base)
      }

      AhoyCaptain.visit.joins(shared_context.join_sources)
            .where(shared_conditions.reduce(&:or))

    end

    def is_a?(other)
      if other == ActiveRecord::Relation
        return true
      end

      super(other)
    end
  end
end
