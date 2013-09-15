class AddLikesCountsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :likes_count, :integer, default: 0
    add_index :questions, :likes_count
  end
end
