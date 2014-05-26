class RemoveIsFeaturedFromQuestions < ActiveRecord::Migration
  def change
    remove_column :questions, :is_featured, :boolean
  end
end
