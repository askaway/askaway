class DropRepTable < ActiveRecord::Migration
  def up
    drop_table :reps
    Answer.destroy_all
  end

  def down
    create_table :reps do |t|
      t.string :name
      t.string :email
      t.string :authorization
      t.string :avatar

      t.timestamps
    end
  end
end
