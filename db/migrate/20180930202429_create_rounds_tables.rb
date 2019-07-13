class CreateRoundsTables < ActiveRecord::Migration[5.0]
  def change
    create_table :round_individual do |t|
    	t.references :player_a, index: true, foreign_key:{to_table: :users}
    	t.references :player_b, index: true, foreign_key:{to_table: :users}
    	t.belongs_to :system
    	t.integer :round
    	t.integer :player_a_points
    	t.integer :player_b_points
    end

    create_table :round_aggregate do |t|
    	t.references :player, index: true, foreign_key:{to_table: :users}
    	t.belongs_to :system
    	t.integer :wins
    	t.integer :losses
    	t.integer :draws
    	t.integer :total_points
    	t.integer :opponents, array: true
    	t.boolean :withdrawn
    end
  end
end
