class AddRnzApprovedColumnToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :rnz_approved, :boolean, default: false
  end
end
