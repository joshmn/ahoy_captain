module AhoyCaptain
  # this is incredibly naive and needs some tlc
  class FunnelPresenter
    class Step
      attr_accessor :goal_1
      attr_accessor :goal_2
      attr_accessor :goal_1_count
      attr_accessor :goal_2_count

      def enter_label
        if goal_2
          "Visitors"
        else
          "Entered the funnel"
        end
      end

      def exit_label
        if goal_2
          "Dropoff"
        else
          "Never entered the funnel"
        end
      end

      def title
        if goal_2
          [goal_1.title, "->", goal_2.title].join(" ")
        else
          goal_1.title
        end
      end
    end

    attr_reader :steps
    def initialize(funnel, event_query)
      @funnel = funnel
      @event_query = event_query.joins(:events)
      @steps = []
    end

    def build
      queries = {}
      queries = {}
      prev_goal = nil
      prev_table = nil
      selects = []
      @funnel.goals.each do |goal|
        if prev_goal
          query = ::Ahoy::Event
                    .select("distinct ahoy_events.visit_id")
                    .from(prev_table.to_s)
                    .joins("inner join ahoy_events on ahoy_events.visit_id = #{prev_table}.id")
                    .where("ahoy_events.name = ?", goal.event_name.to_s).to_sql
          prev_table = "#{goal.id}"
          selects << ["SELECT '#{prev_goal.title} > #{goal.title}' as step, count(*) from #{prev_table}"]
          queries[prev_table] = query
        else
          prev_table = :visitors
          prev_goal = goal

          query = ::Ahoy::Event
                    .select("distinct(visit_id) as id, min(time) as min_time")
                    .where(name: goal.event_name.to_s)
                    .group("1").to_sql
          selects << ["'#{goal.title}' as step, count(*) from #{prev_table}"]

          queries[prev_table] = query
        end
      end

      select = selects.join(" UNION ").delete_suffix(" from #{prev_table}")

      steps = ::Ahoy::Event.with(
        queries
      ).select(select).from(prev_table).order("count desc")

      @result = ::Ahoy::Event.with(steps: steps).select("step, count, lag(count, 1) over () as lag, round((1.0 - count::numeric/lag(count, 1) over ()),2) as drop_off").from("steps")
      abort
    end

    def to_chart

      @steps.map do |step|
        [step.title, step.goal_1_count]
      end
    end
  end
end
