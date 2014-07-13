class AddEditedAtToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :edited_at, :datetime
  end
end
