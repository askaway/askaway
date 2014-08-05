class AddSelectedAvatarTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :selected_avatar_type, :string
    add_column :users, :selected_avatar_identity_id, :integer
  end
end
