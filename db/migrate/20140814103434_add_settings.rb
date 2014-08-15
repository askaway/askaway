class AddSettings < ActiveRecord::Migration
  def up
    create_table :settings do |t|
      t.string :name, unique: true
      t.string :value
    end

    Setting.put(:time_weight, 10)
    Setting.put(:answer_weight, 0)
  end

  def down
    drop_table :settings
  end
end
