module AhoyCaptain
  module Ahoy
    module EventMethods
      extend ActiveSupport::Concern

      included do
        ransacker :route do |parent|
          Arel.sql(AhoyCaptain.config.event[:url_column].gsub("properties", "ahoy_events.properties"))
        end

        scope :with_routes, -> { where(AhoyCaptain.config.event[:url_exists]) }

        scope :with_url, -> {
          select(Arel.sql("#{AhoyCaptain.config.event.url_column} AS url"))
        }

        scope :distinct_url, -> {
          distinct(Arel.sql("#{AhoyCaptain.config.event.url_column}"))
        }

        scope :url_in, ->(*args) {
          where("#{AhoyCaptain.config.event.url_column} IN (?)", args)
        }

        scope :url_eq, ->(arg) {
          if arg.is_a?(Array)
            arg = arg[0]
          end
          where("#{AhoyCaptain.config.event.url_column} = ?", arg)
        }

        scope :url_not_in, ->(*args) {
          where("#{AhoyCaptain.config.event.url_column} NOT IN (?)", args)
        }

        scope :url_i_cont, ->(arg) {
          where("#{AhoyCaptain.config.event.url_column} ILIKE ?", "%#{arg}%")
        }

        scope :route_eq, ->(arg) {
          url_eq(arg)
        }

        scope :route_in, ->(*args) {
          url_in(*args)
        }

        scope :route_not_in, ->(*args) {
          url_not_in(*args)
        }

        scope :route_i_cont, ->(arg) {
          url_i_cont(arg)
        }

        scope :entry_page_in, ->(*args) {
          table_alias = "first_events_#{SecureRandom.hex.first(6)}"

          subquery = self.select("MIN(id) as min_id").where(name: AhoyCaptain.config.event[:view_name]).route_in(*args).group(:visit_id)
          joins("INNER JOIN (#{subquery.to_sql}) #{table_alias} ON #{::AhoyCaptain.event.table_name}.id = #{table_alias}.min_id")
        }

        scope :entry_page_not_in, ->(*args) {
          table_alias = "first_events_#{SecureRandom.hex.first(6)}"
          subquery = self.select("MIN(id) as min_id").where(name: AhoyCaptain.config.event[:view_name]).route_not_in(*args).group(:visit_id)
          joins("INNER JOIN (#{subquery.to_sql}) #{table_alias} ON #{::AhoyCaptain.event.table_name}.id = #{table_alias}.min_id")
        }

        scope :entry_page_i_cont, ->(arg) {
          table_alias = "first_events_#{SecureRandom.hex.first(6)}"
          subquery = self.select("MIN(id) as min_id").where(name: AhoyCaptain.config.event[:view_name]).route_i_cont(arg).group(:visit_id)
          joins("INNER JOIN (#{subquery.to_sql}) #{table_alias} ON #{::AhoyCaptain.event.table_name}.id = #{table_alias}.min_id")
        }

        scope :exit_page_in, ->(*args) {
          table_alias = "last_events_#{SecureRandom.hex.first(6)}"

          subquery = self.select("MAX(id) as max_id").where(name: AhoyCaptain.config.event[:view_name]).route_in(*args).group(:visit_id)
          joins("INNER JOIN (#{subquery.to_sql}) #{table_alias} ON #{::AhoyCaptain.event.table_name}.id = #{table_alias}.max_id")
        }

        scope :exit_page_not_in, ->(*args) {
          table_alias = "last_events_#{SecureRandom.hex.first(6)}"

          subquery = self.select("MAX(id) as max_id").where(name: AhoyCaptain.config.event[:view_name]).route_not_in(*args).group(:visit_id)
          joins("INNER JOIN (#{subquery.to_sql}) #{table_alias} ON #{::AhoyCaptain.event.table_name}.id = #{table_alias}.max_id")
        }

        scope :exit_page_i_cont, ->(arg) {
          table_alias = "last_events_#{SecureRandom.hex.first(6)}"

          subquery = self.select("MAX(id) as max_id").where(name: AhoyCaptain.config.event[:view_name]).route_i_cont(*arg).group(:visit_id)
          joins("INNER JOIN (#{subquery.to_sql}) #{table_alias} ON #{::AhoyCaptain.event.table_name}.id = #{table_alias}.max_id")
        }

      end

      class_methods do
        def ransackable_attributes(auth_object = nil)
          super + ["action", "controller", "id", "id_property", "name", "name_property", "page", "properties", "time", "url", "user_id", "visit_id"] + self._ransackers.keys
        end

        def ransackable_scopes(auth_object = nil)
          super + [:entry_page_in, :entry_page_not_in, :exit_page_in, :entry_page_not_in, :route_in, :route_not_in, :route_i_cont, :entry_page_i_cont, :exit_page_i_cont]
        end

        def ransackable_associations(auth_object = nil)
          super + [:visit]
        end
      end
    end
  end
end

