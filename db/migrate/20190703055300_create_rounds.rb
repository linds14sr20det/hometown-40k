class CreateRounds < ActiveRecord::Migration[5.2]
  def change
    create_table :rounds do |t|
      t.belongs_to :system
      t.integer :round
      t.timestamps
    end
  end
end
