class AddIpAddressToVotes < ActiveRecord::Migration
  def up
    add_column :votes, :ip_address, :string, index: true
    change_column :votes, :user_id, :integer, index: true, null: true
  end
  def down
    remove_column :votes, :ip_address, :string
    change_column :votes, :user_id, :integer, index: true, null: false
  end
end
