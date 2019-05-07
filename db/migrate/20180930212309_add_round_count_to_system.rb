class AddRoundCountToSystem < ActiveRecord::Migration[5.0]
  def change
  	add_column :systems, :round_individuals, :integer
  end
end
