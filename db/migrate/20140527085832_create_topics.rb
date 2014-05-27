class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.timestamps
    end
    add_column :questions, :topic_id, :integer
    add_index :questions, :topic_id
  end
end
