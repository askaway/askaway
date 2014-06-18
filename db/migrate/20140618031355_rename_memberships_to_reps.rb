class RenameMembershipsToReps < ActiveRecord::Migration
  def change
    rename_table :memberships, :reps
  end
end
