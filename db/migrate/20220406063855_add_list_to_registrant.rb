class AddListToRegistrant < ActiveRecord::Migration[6.0]
  def change
    add_column :registrants, :list, :string
    add_column :registrants, :faction, :string
  end
end
