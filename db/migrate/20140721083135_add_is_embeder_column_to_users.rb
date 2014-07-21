class AddIsEmbederColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_embedder, :boolean, default: false
  end
end
