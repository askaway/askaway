class RemoveNameAndEmailFromQuestions < ActiveRecord::Migration
  def change
    remove_column :questions, :name, :string
    remove_column :questions, :email, :string
  end
end
