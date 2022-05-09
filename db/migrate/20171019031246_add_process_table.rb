class AddProcessTable < ActiveRecord::Migration[5.1]
  def change
    create_table :psp_processes do |t|
      t.string :name, null: false, unique: true
      t.timestamps
    end
  end
end
