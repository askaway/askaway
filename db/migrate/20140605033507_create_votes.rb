class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :question, index: true, null: false
      t.references :user, index: true, null: false

      t.timestamps
    end
  end
end
