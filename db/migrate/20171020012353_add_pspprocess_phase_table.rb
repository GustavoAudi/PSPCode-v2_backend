# frozen_string_literal: true

class AddPspprocessPhaseTable < ActiveRecord::Migration[5.1]
  def change
    create_table :psp_process_phases do |t|
      t.references :phase
      t.references :psp_process
      t.timestamps
    end
  end
end
