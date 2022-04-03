# frozen_string_literal: true

class AddDefectsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :defects do |t|
      t.datetime :discovered_time, null: false
      t.references :phase_injected, null: false
      t.references :phase_instance, null: false
      t.integer :defect_type, null: false
      t.integer :fix_defect
      t.datetime :fixed_time, null: false
      t.string :description, null: false
    end
  end
end
