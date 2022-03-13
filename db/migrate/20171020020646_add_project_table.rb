class AddProjectTable < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.references :process, null: false
      t.string :description_file
      t.timestamps
    end
  end
end
