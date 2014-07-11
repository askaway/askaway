class CreateTopicRnzs < ActiveRecord::Migration
  def change
    create_table :topic_rnzs do |t|
      t.string :name
      t.timestamps
    end
    add_column :questions, :topic_rnz_id, :integer
    add_index :questions, :topic_rnz_id
  end
end
