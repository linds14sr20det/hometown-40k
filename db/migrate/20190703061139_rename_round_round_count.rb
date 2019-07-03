class RenameRoundRoundCount < ActiveRecord::Migration[5.2]
  def change
    rename_column :systems, :rounds, :round_count
  end
end
