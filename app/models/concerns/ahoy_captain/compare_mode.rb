module AhoyCaptain
  module CompareMode
    def self.included(klass)
      if klass < ActionController::Base
        klass.helper_method :compare_mode?
        klass.helper_method :comparison_label
      end
    end

    # doesn't work for realtime and realtime doesn't need a secondary range
    def compare_mode?
      comparison_mode.enabled?
    end

    def comparison_mode
      @comparison_mode ||= ComparisonMode.new(params)
    end
  end
end
