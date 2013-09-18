class AddFeaturedToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :is_featured, :boolean, default: false
    add_index :questions, :is_featured
    Question.reset_column_information

    unless Question.count==0
      Question.first.update_attribute(:is_featured, true)
    end
  end
end
