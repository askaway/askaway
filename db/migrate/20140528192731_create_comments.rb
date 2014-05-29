class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :question, index: true
      t.belongs_to :user, index: true
      t.text :body

      t.timestamps
    end
  end
end
