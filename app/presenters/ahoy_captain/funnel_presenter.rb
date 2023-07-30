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
    def initialize(funnel, visit_query)
      @funnel = funnel
      @visit_query = visit_query.joins(:events)
      @steps = []
    end

    def build
      funnel_data = []
      funnel_query_results = {}
      did_not_enter = @funnel.goals.first
      did_not_enter_count = @visit_query.where.not(ahoy_events: { name: did_not_enter.event_name }).count
      current_steps = []
      # Fetch visitor counts for all events in the funnel in a single query
      @funnel.goals.each do |goal|
        current_steps << goal
        current_steps.each do |step|
          funnel_query_results[goal.id] = @visit_query.where(ahoy_events: { name: step.event_name })
        end

        funnel_query_results[goal.id] = funnel_query_results[goal.id].count
      end

      previous_goal = nil

      @funnel.goals.each do |goal|
        visitors_count = funnel_query_results[goal.id]
        step = Step.new
        if previous_goal.nil?
          step.tap do |step|
            step.goal_1 = goal
            step.goal_1_count = visitors_count
            step.goal_2_count = did_not_enter_count
          end
        else
          step.tap do |step|
            step.goal_1 = goal
            step.goal_2 = previous_goal
            step.goal_1_count = visitors_count
            step.goal_2_count = funnel_query_results[previous_goal.id] - visitors_count
          end
        end

        @steps << step

        previous_goal = goal
      end

      self
    end

    def to_chart

      @steps.map do |step|
        [step.title, step.goal_1_count]
      end
    end
  end
end
