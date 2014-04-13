class CreateItems < ActiveRecord::Migration
  def up
    drop_table :items
    
    create_table :items do |t|
      t.string :type
      t.string :title
      t.text :description
      t.integer :user_id

      t.timestamps
    end
  end
end
