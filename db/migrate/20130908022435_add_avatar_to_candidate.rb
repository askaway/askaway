class AddAvatarToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :avatar, :string
  end
end
