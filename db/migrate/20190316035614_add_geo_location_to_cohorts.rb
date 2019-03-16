class AddGeoLocationToCohorts < ActiveRecord::Migration[5.0]
  def change
    add_column :cohorts, :body, :string
    add_column :cohorts, :street, :string
    add_column :cohorts, :city, :string
    add_column :cohorts, :state, :string
    add_column :cohorts, :country, :string
    add_column :cohorts, :latitude, :float
    add_column :cohorts, :longitude, :float
  end
end
