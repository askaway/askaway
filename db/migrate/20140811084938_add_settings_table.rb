class AddSettingsTable < ActiveRecord::Migration
  def up
    create_table :settings do |t|
      t.hstore :values
    end

    Setting.set(:time_weight, 450000)
    Setting.set(:answer_weight, 0)
  end

  def down
    drop_table :settings
  end
end
