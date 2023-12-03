class AddCriterionTable < ActiveRecord::Migration[6.1]
  def change
    create_table :criteria do |t|
      t.string :description, null: false
      t.boolean :only_in_psp01, default: false
      t.references :section, null: false
      t.integer :order, null: false
      t.integer :algorithm, default: nil
      t.integer :algorithm_type, default: nil
    end
  end
end
