class AddEventStartedToSystems < ActiveRecord::Migration[5.2]
  def change
    add_column :systems, :event_started, :boolean
  end
end
