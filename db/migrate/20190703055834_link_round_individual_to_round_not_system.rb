class LinkRoundIndividualToRoundNotSystem < ActiveRecord::Migration[5.2]
  def change
    change_table :round_individuals do |t|
      t.remove_references :system
    end
    change_table :round_individuals do |t|
      t.belongs_to :round
    end
  end
end
