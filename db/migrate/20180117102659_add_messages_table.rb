class AddMessagesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.string :text, null: false
      t.integer :sender_id, null: false
      t.string :sender_type, null: false
      t.references :assigned_project, null: false
      t.timestamps
    end
  end
end
