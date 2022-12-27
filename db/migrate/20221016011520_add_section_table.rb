class AddSectionTable < ActiveRecord::Migration[6.1]
  def change
    create_table :sections do |t|
      t.string :name, null: false
    end
  end
end
