class AddWorkflowStateToComment < ActiveRecord::Migration
  def change
    add_column :comments, :workflow_state, :string, default: 'default'
    add_index :comments, :workflow_state
  end
end
