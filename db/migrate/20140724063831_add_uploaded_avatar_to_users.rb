class AddUploadedAvatarToUsers < ActiveRecord::Migration
  def up
    add_attachment :users, :uploaded_avatar
  end
  def down
    remove_attachment :users, :uploaded_avatar
  end
end
