class AddRankingCacheToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :ranking_cache, :integer
  end
end
