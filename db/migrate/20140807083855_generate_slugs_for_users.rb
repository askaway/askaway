class GenerateSlugsForUsers < ActiveRecord::Migration
  class User < ActiveRecord::Base
    include FriendlyId
    friendly_id :name, :use => [:slugged]
  end

  def up
    add_column :users, :slug, :string
    add_index :users, :slug, unique: true
    User.reset_column_information
    User.find_each do |u|
      u.save
      # update even if save fails
      unless u.valid?
        u.update_attribute(:slug, u.slug)
      end
    end
  end

  def down
    remove_column :users, :slug
  end
end
