class CreateRepTopics < ActiveRecord::Migration
  def change
    create_table :rep_topics do |t|
      t.references :rep, index: true
      t.references :topic, index: true

      t.timestamps
    end
  end
end
