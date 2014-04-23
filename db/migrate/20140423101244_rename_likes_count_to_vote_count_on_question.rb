class RenameLikesCountToVoteCountOnQuestion < ActiveRecord::Migration
  def change
    rename_column :questions, :likes_count, :vote_count
  end
end
