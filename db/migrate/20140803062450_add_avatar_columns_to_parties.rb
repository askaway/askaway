class AddAvatarColumnsToParties < ActiveRecord::Migration
  class Party < ActiveRecord::Base; end

  def up
    add_attachment :parties, :uploaded_avatar
    add_column :parties, :placeholder_id, :integer
    add_column :parties, :selected_avatar_type, :string
    add_column :parties, :selected_avatar_identity_id, :integer
    Party.find_each do |party|
      party.update_attribute(:placeholder_id, 99)
    end
  end

  def down
    remove_attachment :parties, :uploaded_avatar
    remove_column :parties, :placeholder_id, :integer
    remove_column :parties, :selected_avatar_type, :string
    remove_column :parties, :selected_avatar_identity_id, :integer
  end
end
