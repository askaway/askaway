class AddAnswersCounterToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :answers_count, :integer, default: 0
    add_index :questions, :answers_count

    Question.reset_column_information
    Question.find_each do |q|
      q.update_attribute(:answers_count, q.answers.count)
    end
  end
end
