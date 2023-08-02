class ApplicationRecord < ActiveRecord::Base
  include PpSql::ToSqlBeautify
end
