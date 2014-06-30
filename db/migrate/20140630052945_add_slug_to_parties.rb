class AddSlugToParties < ActiveRecord::Migration
  class Party < ActiveRecord::Base
    include FriendlyId
    friendly_id :name, :use => [:slugged]
  end

  def up
    add_column :parties, :slug, :string
    add_index :parties, :slug, unique: true
    Party.reset_column_information
    Party.find_each(&:save)
  end

  def down
    remove_column :parties, :slug
  end
end
