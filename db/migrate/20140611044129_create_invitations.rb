class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :email
      t.string :name
      t.string :inviter_id
      t.string :intent
      t.integer :invitable_id
      t.string :invitable_type
      t.integer :acceptor_id
      t.datetime :accepted_at
      t.string :token, null: false

      t.timestamps
    end
    add_index :invitations, [:invitable_id, :invitable_type]
    add_index :invitations, :email
    add_index :invitations, :token
    add_index :invitations, :inviter_id
  end
end
