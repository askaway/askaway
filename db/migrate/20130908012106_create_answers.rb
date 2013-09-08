class CreateAnswers < ActiveRecord::Migration
  create_table :answers do |t|
    t.text :body
    t.references :candidate
    t.references :question

    t.timestamps
  end
end
