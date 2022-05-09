class AddMessageNotificationsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :message_notifications do |t|
      t.references :assigned_project, null: false
      t.string :originator_type, null: false
      t.integer :originator_id, null: false
      t.string :receiver_type, null: false
      t.integer :receiver_id, null: false
      t.references :message, null: false
      t.timestamps
    end
  end
end
