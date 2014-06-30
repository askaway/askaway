class AddSlugToQuestions < ActiveRecord::Migration
  class Question < ActiveRecord::Base
    include FriendlyId
    friendly_id :body, :use => [:slugged]
  end

  def up
    add_column :questions, :slug, :string
    add_index :questions, :slug, unique: true
    Question.reset_column_information
    Question.find_each(&:save)
  end

  def down
    remove_column :questions, :slug
  end
end
