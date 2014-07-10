class AddCancelledAtToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :cancelled_at, :datetime
  end
end
