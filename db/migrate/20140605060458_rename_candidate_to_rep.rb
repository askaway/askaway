class RenameCandidateToRep < ActiveRecord::Migration
  def change
    rename_table :candidates, :reps
    rename_column :answers, :candidate_id, :rep_id
  end
end
