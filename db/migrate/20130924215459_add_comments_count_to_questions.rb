class AddCommentsCountToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :comments_count, :integer, default: 0
    add_index :questions, :comments_count
  end
end
