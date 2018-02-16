class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.string :url
      t.references :submission, foreign_key: true
      t.timestamps
    end
  end
end
