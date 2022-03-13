class AddEventsNotificationsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :event_notifications do |t|
      t.references :assigned_project, null: false
      t.string :originator_type, null: false
      t.integer :originator_id, null: false
      t.string :receiver_type, null: false
      t.integer :receiver_id, null: false
      t.string :status, null: false
      t.timestamps
    end
  end
end
