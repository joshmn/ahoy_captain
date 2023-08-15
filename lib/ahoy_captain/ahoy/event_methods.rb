module AhoyCaptain
  module Ahoy
    module EventMethods
      extend ActiveSupport::Concern

      included do
        scope :page_view, -> { where("name = '#{AhoyCaptain.config.event[:view_name]}'") }

        ransacker :route do |_parent|
          Arel.sql(AhoyCaptain.config.event[:url_column])
        end

        ransacker :entry_page do |parent|
          Arel.sql("entry_pages.url")
        end

        ransacker :exit_page do |parent|
          Arel.sql("exit_pages.url")
        end

        scope :with_entry_pages, -> {
          with(entry_pages: self.select("MIN(#{table_name}.id) as min_id, #{Arel.sql("#{AhoyCaptain.config.event.url_column} AS url")}").where(name: AhoyCaptain.config.event[:view_name]).group("#{table_name}.properties")).joins("INNER JOIN entry_pages ON entry_pages.min_id = #{table_name}.id")
        }

        scope :with_exit_pages, -> {
          with(exit_pages: self.select("MAX(#{table_name}.id) as max_id, #{Arel.sql("#{AhoyCaptain.config.event.url_column} AS url")}")
                               .where(name: AhoyCaptain.config.event[:view_name]).group("#{table_name}.properties"))
            .joins("INNER JOIN exit_pages ON exit_pages.max_id = #{table_name}.id")
        }

        scope :with_routes, -> { where(AhoyCaptain.config.event[:url_exists]) }

        scope :with_url, -> {
          select(Arel.sql("#{AhoyCaptain.config.event.url_column} AS url"))
        }

        scope :distinct_url, -> {
          distinct(Arel.sql("#{AhoyCaptain.config.event.url_column}"))
        }

        ransacker :property_name,
                  formatter: ->(value) {
                    quoted = connection.quote(value)
                    Arel.sql("select id from ahoy_events where JSONB_EXISTS(properties, #{quoted})")
                  } do |parent|
          parent.table[:id]
        end

        ransacker :goal,
                  formatter: ->(value) {
                    ::Arel::Nodes::SqlLiteral.new(
                      ::AhoyCaptain.config.goals[value].event_query.call.select(:id).to_sql
                    )
                  } do |parent|
          parent.table[:id]
        end
      end

      class_methods do
        def ransackable_attributes(auth_object = nil)
          super + ["action", "controller", "id",  "name", "page", "property_name", "properties", "time", "url", "user_id", "visit_id", "goal"] + self._ransackers.keys
        end

        def ransackable_scopes(auth_object = nil)
          super
        end

        def ransackable_associations(auth_object = nil)
          super + [:visit]
        end
      end
    end
  end
end

