class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :body
      t.string :name
      t.string :email
      t.boolean :is_anonymous

      t.timestamps
    end
    add_index :questions, :name
    add_index :questions, :email
  end
end
