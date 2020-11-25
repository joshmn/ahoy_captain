class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    drop_table :companies if table_exists?(:companies)
    create_table :companies do |t|

      t.timestamps
    end
  end
end
