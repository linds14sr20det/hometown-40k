class CreateRoundsTables < ActiveRecord::Migration[5.0]
  def change
    create_table :round_individuals do |t|
    	t.references :player, index: true, foreign_key:{to_table: :users}
    	t.references :opponent, index: true, foreign_key:{to_table: :users}
    	t.belongs_to :system
    	t.integer :round
    	t.integer :points
    	t.boolean :win
    	t.boolean :loss
    	t.boolean :draw
    end

    create_table :round_aggregates do |t|
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
