class RemoveStatusFromQuestions < ActiveRecord::Migration
  def change
    remove_column :questions, :status, :string
  end
end
