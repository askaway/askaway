class AddPlaceholderIdToUsers < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end

  def up
    add_column :users, :placeholder_id, :integer
    User.find_each do |user|
      user.update_attribute(:placeholder_id, rand(5))
    end
  end

  def down
    remove_column :users, :placeholder_id
  end
end
