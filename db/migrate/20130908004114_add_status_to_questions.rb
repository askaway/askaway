class AddStatusToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :status, :string
    add_index :questions, :status
  end
end
