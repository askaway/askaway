class ReAddCommentsCountToQuestion < ActiveRecord::Migration
  class Question < ActiveRecord::Base
    has_many :comments
  end

  def up
    add_column :questions, :comments_count, :integer, default: 0, null: false
    Question.reset_column_information
    Question.find_each do |question|
      Question.reset_counters(question.id, :comments)
    end
  end

  def down
    remove_column :questions, :comments_count
  end
end
