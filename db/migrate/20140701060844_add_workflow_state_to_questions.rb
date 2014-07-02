class AddWorkflowStateToQuestions < ActiveRecord::Migration
  class Question < ActiveRecord::Base; end
  def up
    add_column :questions, :workflow_state, :string
    Question.reset_column_information
    Question.update_all(workflow_state: 'default')
  end

  def down
    remove_column :questions, :workflow_state
  end
end
