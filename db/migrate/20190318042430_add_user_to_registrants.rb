class AddUserToRegistrants < ActiveRecord::Migration[5.2]
  def change
    add_reference :registrants, :user
    remove_column :registrants, :name
    remove_column :registrants, :email
  end
end
