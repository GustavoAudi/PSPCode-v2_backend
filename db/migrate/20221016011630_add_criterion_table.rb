class AddCriterionTable < ActiveRecord::Migration[6.1]
  def change
    create_table :criteria do |t|
      t.string :description
      t.boolean :not_exists_in_psp00, default: false
      t.references :section, null: false
    end
  end
end
