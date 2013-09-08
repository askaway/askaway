class AddAuthorisationToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :authorisation, :string
  end
end
