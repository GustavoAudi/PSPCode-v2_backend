# frozen_string_literal: true

class ChangeStartTypeEndTypeColumnTypeForPhaseInstances < ActiveRecord::Migration[5.1]
  def change
    change_column :phase_instances, :start_time,
                  'timestamp USING start_time::timestamp without time zone'
    change_column :phase_instances, :end_time,
                  'timestamp USING start_time::timestamp without time zone'
  end
end
