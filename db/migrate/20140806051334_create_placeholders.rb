class CreatePlaceholders < ActiveRecord::Migration
  def up
    create_table :placeholders do |t|
      t.timestamps
    end
    add_attachment :placeholders, :uploaded_avatar
  end

  def down
    drop_table :placeholders
  end
end
