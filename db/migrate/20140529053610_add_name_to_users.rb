class AddNameToUsers < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end

  def up
    add_column :users, :name, :string

    User.reset_column_information
    User.where(name: nil).find_each do |user|
      user.update_attribute :name, user.email
    end
    change_column :users, :name, :string, null: false
  end

  def down
    remove_column :users, :name
  end
end
