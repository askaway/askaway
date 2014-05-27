class RemoveCommentsCountFromQuestions < ActiveRecord::Migration
  def change
    remove_column :questions, :comments_count, :integer
  end
end
