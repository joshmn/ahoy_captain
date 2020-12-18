# frozen_string_literal: true

require 'rails/generators/base'

module Caffeinate
  module Generators
    module ViewPathTemplates #:nodoc:
      extend ActiveSupport::Concern

      included do
        public_task :copy_views
      end

      def copy_views
        view_directory :campaign_subscriptions
      end

      protected

      def view_directory(name, _target_path = nil)
        directory name.to_s, _target_path || "#{target_path}/#{name}" do |content|
          content
        end
      end

      def target_path
        @target_path ||= "app/views/caffeinate"
      end
    end

    class SharedViewsGenerator < Rails::Generators::Base #:nodoc:
      include ViewPathTemplates
      source_root File.expand_path("../../../../app/views/caffeinate", __FILE__)
      desc "Copies shared Caffeinate views to your application."
      hide!
    end

    class ViewsGenerator < Rails::Generators::Base
      desc "Copies Caffeinate views to your application."

      invoke SharedViewsGenerator
    end
  end
end
