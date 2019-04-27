class AddPayPalToCohort < ActiveRecord::Migration[5.2]
  def change
    add_column :cohorts, :paypal_client_id, :string
    add_column :cohorts, :paypal_client_secret, :string
  end
end
