class AddUnderModerationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :under_moderation, :boolean, null: false, default: false
  end
end
