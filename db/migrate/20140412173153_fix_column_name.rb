class FixColumnName < ActiveRecord::Migration
  def self.up
  	rename_column :items, :type, :category
  end
end
