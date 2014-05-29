class AddUserIdToQuestions < ActiveRecord::Migration
  class Question < ActiveRecord::Base
    belongs_to :user
  end
  class User < ActiveRecord::Base
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable
  end

  def up
    add_column :questions, :user_id, :integer
    add_index :questions, :user_id

    user = User.find_by(email: 'unknown@askaway.co.nz')
    user ||= User.create!(name: 'Unknown User',
                       email: 'unknown@askaway.co.nz',
                       password: 'password')

    Question.reset_column_information
    Question.where(user_id: nil).update_all(user_id: user.id)

    change_column :questions, :user_id, :integer, null: false
  end

  def down
    remove_column :questions, :user_id
  end
end
