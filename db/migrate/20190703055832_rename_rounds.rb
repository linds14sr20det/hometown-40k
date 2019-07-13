class RenameRounds < ActiveRecord::Migration[5.2]
  def change
    rename_table :round_individual, :round_individuals
    rename_table :round_aggregate, :round_aggregates
  end
end
