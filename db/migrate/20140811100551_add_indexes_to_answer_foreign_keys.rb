class AddIndexesToAnswerForeignKeys < ActiveRecord::Migration
  def change
    add_index :answers, :question_id
    add_index :answers, :rep_id
  end
end
